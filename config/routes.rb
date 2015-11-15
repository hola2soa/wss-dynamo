Dir.glob('./app/controllers/**/*.rb').each { |file| require file }
require 'sinatra/base'
require 'sinatra/flash'
require 'httparty'
require 'hirb'
require 'slim'

class SinatraApp < Sinatra::Base
	  register Sinatra::Namespace
      helpers QueenshopHelper
	  enable :sessions
	  register Sinatra::Flash
	  use Rack::MethodOverride

	  set :views, File.expand_path('../../app/views', __FILE__) #ok
	  set :public_folder, File.expand_path('../../app/public', __FILE__)

	  configure do
	    Hirb.enable
	    set :session_secret, 'something'
	    set :api_ver, 'api/v1'
	  end

	  configure :development, :test do
	    set :api_server, 'http://localhost:9292'
	  end

	  configure :production do
	   # set :api_server, 'http://hola2soa-api.herokuapp.com'
	    set :api_server, 'http://powerful-basin-8880.herokuapp.com'
	  end

	  configure :production, :development do
	    enable :logging
	  end 	
	  
	  helpers do
		def current_page?(path = ' ')
		  path_info = request.path_info
		  path_info += ' ' if path_info == '/'
		  request_path = path_info.split '/'
		  request_path[1] == path
		end
	  end
	  
	
	

	
	
	

	#Web API
	api_get_root = lambda do
		  'Hello,Queenshop is up and working.  Please see documentation at its ' \
		  '<a href="https://github.com/hola2soa/QueenShopWebApi">' \
		  'Github repo - master branch</a>'
	end

    api_show = lambda do
          content_type :json
          get_items(params[:item]).to_json
		  
    end
		
		
    api_post_query = lambda do		
			
		 logger.info  'Enter api_post_query'
          content_type :json 
          begin
            req = JSON.parse(request.body.read)
            logger.info req
          rescue => e
            logger.error "Error: #{e.message}"
            logger.info  'api_post_query-Error occcur1'
			halt 400
          end
			 logger.info  req['items']
			 logger.info  req['prices']
			 logger.info  req['pages']
			 
          requests = Request.new(
            items: req['items'].to_json,
            prices: req['prices'].to_json,
            pages: req['pages'].to_json
          )

          if requests.save
		   logger.info  'api_post_query-requests.save'
            status 201
			logger.info "#{settings.api_ver}"
			logger.info "#{requests.id}"
            redirect "/#{settings.api_ver}/query/#{requests.id}", 303
          else
			logger.info  'api_post_query-Error saving request to database'
            logger.error 'Error saving request to database'
            halt 500, 'Error saving request request to the database'
          end
		 logger.info  'leave api_post_query'
    end

		
     api_get_query = lambda do
         logger.info  'Enter api_get_query_id'
          content_type :json
          begin
            requests = Request.find(params[:id])
            items = JSON.parse(requests.items)
            prices = JSON.parse(requests.prices)
            pages = JSON.parse(requests.pages)
          rescue
		    logger.info  'api_get_query_id-Error while fetching request from database'
            logger.error 'Error while fetching request from database'
            halt 400
          end
			
          begin
            results = check_items(items, prices, pages).to_json
          rescue
            logger.error 'Lookup of Queenshop failed'
            halt 500, 'Lookup of Queenshop failed'
          end

          { id: requests.id, items: items,
            prices: prices, pages: pages
          }.to_json
		  logger.info  'leave api_get_query_id'

    end
		
		api_delete_query = lambda do
			request = Request.destroy(params[:id])
			status(request > 0 ? 200 : 404)
		end
		
	#Web API routes	
		get '/api/v1/?', &api_get_root
        get '/api/v1/:item', &api_show
        get '/api/v1/query/:id', &api_get_query
        post '/api/v1/query/?', &api_post_query
	    delete '/api/v1/query/:id', &api_delete_query
	
	
	
	
	
	#web APP
	app_get_root = lambda do	 
		 slim :home
	end
	  
	app_get_show = lambda do
		@item=params[:item]
		if @item
		  redirect "/show/#{@item}"
		  return nil
		end

		slim :show
	
	end
	
	app_get_show_item = lambda do
		@item = params[:item]
		@products = get_items(@item)

		if @item && @products.nil?
		  flash[:notice] = 'item not found' if @products.nil?
		  redirect '/show'
		  return nil
		end

		slim :show
	end
	
	
	
	app_get_query = lambda do

		@action = :create
		slim :query

	end
  
  
  
	app_post_query  = lambda do  #1
		logger.info  'Enter app_post_query'
		
		request_url = "#{settings.api_server}/#{settings.api_ver}/query"
		logger.info "#{settings.api_server}"
		
		
		prices = params[:prices]
		pages = params[:pages]
		items = params[:items]
		
		params_h = {
		  prices: prices,
		  pages: pages,
		  items: items
		}

		options =  {  body: params_h.to_json,
					  headers: { 'Content-Type' => 'application/json' }
				   }
	
	   
		result = HTTParty.post(request_url, options)   #post http://powerful-basin-8880.herokuapp.com/api/v1/query"  #Application error
		logger.info  'app_post_query-After HTTParty.post(request_url, options)'

		if (result.code != 200)
		  flash[:notice] = 'Could not process your request'
		  redirect '/query'
		  return nil
		end
		
		id = result.request.last_uri.path.split('/').last
		session[:results] = result.to_json
		session[:action] = :create
		logger.info  id
		logger.info  'app_post_query-before redirect'
	    redirect "/query/#{id}"
		logger.info  'leave app_post_query'
	end
	
	
	app_get_query_id = lambda do
		  logger.info  'Enter app_get_query_id'
		if session[:action] == :create
		  @results = JSON.parse(session[:results])
		else
		  request_url = "#{settings.api_server}/#{settings.api_ver}/query/#{params[:id]}"
		  options =  { headers: { 'Content-Type' => 'application/json' } }
		  @results = HTTParty.get(request_url, options)
		  if @results.code != 200
			flash[:notice] = 'cannot find item of query'
			redirect '/query'
		  end
		end

		@id = params[:id]
		@action = :update
		@prices = @results['prices']
		@pages = @results['pages']
		@items = @results['items']
	
		slim :query
	end
	
	app_delete_query_id = lambda do
		request_url = "#{settings.api_server}/#{settings.api_ver}/query/#{params[:id]}"
		HTTParty.delete(request_url)
		flash[:notice] = 'record of query deleted'
		redirect '/query'
	end
	
	
	#Web APP routes
	get '/', &app_get_root
	get '/show', &app_get_show
	get '/show/:item', &app_get_show_item
	get '/query', &app_get_query
	post '/query', &app_post_query
	get '/query/:id', &app_get_query_id
	delete '/query/:id', &app_delete_query_id
	
	
	  
	#  namespace '/' do 
	#	register Api::V1::ApplicationController
	#  end

	#  namespace '/api' do
	#	namespace '/v1' do
	#	  namespace '/queenshop' do
	#		register Api::V1::QueenshopController
	#	  end
	#	end
	#  end
end

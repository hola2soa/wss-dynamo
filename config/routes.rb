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
	    set :api_server, 'http://hola2soa-api.herokuapp.com'
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
	  
		#web app
	get_show = lambda do
		@item=params[:item]
		if @item
		  redirect "/show/#{@item}"
		  return nil
		end

		slim :show
	end

	get_show_item = lambda do
		@item = params[:item]
		@products = get_items(@item)

		if @item && @products.nil?
		  flash[:notice] = 'item not found' if @products.nil?
		  redirect '/show'
		  return nil
		end

		slim :show
	end
	
	
	get_query = lambda do
		@action = :create
		slim :query
	end
  
  
  
	post_query  = lambda do
		request_url = "#{settings.api_server}/#{settings.api_ver}/query"
		prices = params[:prices].split("\r\n")
		pages = params[:pages].split("\r\n")
		items = params[:items].split("\r\n")
		
		params_h = {
		  prices: prices,
		  pages: pages,
		  items: items
		}

		options =  {  body: params_h.to_json,
					  headers: { 'Content-Type' => 'application/json' }
				   }

		result = HTTParty.post(request_url, options)

		if (result.code != 200)
		  flash[:notice] = 'Could not process your request'
		  redirect '/query'
		  return nil
		end

		id = result.request.last_uri.path.split('/').last
		session[:results] = result.to_json
		session[:action] = :create
		redirect "/query/#{id}"
	end
	
	
	get_query_id = lambda do
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
	
	delete_query_id = lambda do
		request_url = "#{settings.api_server}/#{settings.api_ver}/query/#{params[:id]}"
		HTTParty.delete(request_url)
		flash[:notice] = 'record of query deleted'
		redirect '/query'
	end
	
	
	app.get '/', &get_root
	app.get '/show', &get_show
	app.get '/show/:item', &get_show_item
	app.get '/query', &get_query
	app.post '/query', &post_query
	app.get '/query/:id', &get_query_id
	app.delete '/query/:id', &delete_query_id
		
		
		
		
	  namespace '/' do 
		register Api::V1::ApplicationController
	  end

	  namespace '/api' do
		namespace '/v1' do
		  namespace '/queenshop' do
			register Api::V1::QueenshopController
		  end
		end
	  end
end

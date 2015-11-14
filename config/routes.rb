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

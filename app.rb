Dir.glob('./app/{helpers,models}/*.rb').each { |file| require file }

class SinatraApp < Sinatra::Base
  enable :sessions
  register Sinatra::Flash
  use Rack::MethodOverride
  # set path to view/public
  set :views, File.expand_path('../app/views', __FILE__) # ok
  set :public_folder, File.expand_path('../app/public', __FILE__)

  # Standard Sinatra configurations
  configure :production, :development do
    enable :logging
  end

  configure :development, :test do
    set :api_server, 'http://localhost:9292'
  end

  configure :production do
    # set :api_server, 'http://hola2soa-api.herokuapp.com'
    set :api_server, 'https://hola2soa-api.herokuapp.com/'
  end

  configure do
    Hirb.enable
    set :session_secret, 'something'
    set :api_ver, 'api/v1'
  end

  helpers QueenshopHelper
  helpers do
    def current_page?(path = ' ')
      path_info = request.path_info
      path_info += ' ' if path_info == '/'
      request_path = path_info.split '/'
      request_path[1] == path
    end
  end
end

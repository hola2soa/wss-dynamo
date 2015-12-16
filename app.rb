
Dir.glob('./app/{helpers,models}/*.rb').each { |file| require file }

class SinatraApp < Sinatra::Base
  enable :sessions

  # Standard Sinatra configurations
  configure :production, :development do
    enable :logging
  end

  configure :development, :test do
    set :api_server, 'http://localhost:9292'
  end

  configure :production do
    set :api_server, 'https://wss-dynamo.herokuapp.com'
  end

  configure do
    set :session_secret, 'something'
    set :api_ver, 'api/v1'
  end

  root = lambda do
    'Queenshop scrapper and two other (under dev)'
  end

  get '/', &root

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

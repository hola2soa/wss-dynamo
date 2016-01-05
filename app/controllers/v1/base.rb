require 'sinatra/base'
require 'active_support'
require 'active_support/core_ext'

class SinatraApp < Sinatra::Base
  enable :cross_origin
  register Sinatra::CrossOrigin
  
  set :allow_origin, :any
  set :allow_methods, [:get, :post, :options]

  configure :development, :test do
    ConfigEnv.path_to_config("#{__dir__}/../../../config/config_env.rb")
    set :api_server, 'http://localhost:9292'
  end

  configure :production, :development do
    enable :logging
  end

  configure :production do
    set :api_server, 'https://wss-dynamo.herokuapp.com'
  end

  use Rack::Session::Cookie, :key => 'rack.session',
     :domain => "#{settings.api_server}",
     :path => '/',
     :expire_after => 122400, # 24 hours
     :secret => 'not23a2!2real%44secret?'

  before do
    @HOST_WITH_PORT = request.host_with_port
  end
end

require 'sinatra/base'
require 'active_support'
require 'active_support/core_ext'

class SinatraApp < Sinatra::Base
  enable :cross_origin
  enable :sessions
  register Sinatra::CrossOrigin

  configure do
    set :allow_origin, :any
    set :allow_methods, [:get, :post, :options]

    sqs = Aws::SQS::Client.new(region: ENV['AWS_REGION'])

    set :hola_queue, sqs
    set :hola_queue_url, sqs.get_queue_url(queue_name: 'RecentRequests').queue_url

    set :wss_cache, Dalli::Client.new((ENV["MEMCACHIER_SERVERS"] || "").split(","),
      { :username => ENV["MEMCACHIER_USERNAME"],
        :password => ENV["MEMCACHIER_PASSWORD"],
        :socket_timeout => 1.5,
        :socket_failure_delay => 0.2
    })
    set :wss_cache_ttl, 1.day    # 24hrs

    set :wss_queue, Aws::SQS::Client.new(region: ENV['AWS_REGION'])
    set :wss_queue_name, 'RecentRequests'
  end

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

  before do
    @HOST_WITH_PORT = request.host_with_port
  end
end

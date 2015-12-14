require 'dynamoid'
require 'sinatra'
require 'config_env'
require 'aws-sdk'

configure :development, :test do
  ConfigEnv.path_to_config("#{__dir__}/config_env.rb")
end

Aws.config.update({
  region: ENV['AWS_REGION'],
  credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
})

Dynamoid.configure do |config|
  config.adapter = 'aws_sdk_v2'
  config.namespace = 'wss'
  config.warn_on_scan = false
  config.read_capacity = 5
  config.write_capacity = 5
end

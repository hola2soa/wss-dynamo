require 'dynamoid'
ConfigEnv.path_to_config("#{__dir__}/config_env.rb")
Aws.config.update({
    region: 'us-west-2',
    credentials: Aws::Credentials.new('REPLACE_WITH_ACCESS_KEY_ID', 'REPLACE_WITH_SECRET_ACCESS_KEY')
})
Dynamoid.configure do |config|
  config.adapter = 'aws_sdk_v2'
  config.namespace = 'wss'
  config.warn_on_scan = false
  config.read_capacity = 5
  config.write_capacity = 5
end

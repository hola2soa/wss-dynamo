require 'dynamoid'

Dynamoid.configure do |config|
  config.adapter = 'aws_sdk_v2'
  config.namespace = 'wss'
  config.warn_on_scan = false
  config.read_capacity = 5
  config.write_capacity = 5
end

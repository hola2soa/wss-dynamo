source 'http://rubygems.org'
ruby '2.2.0'

gem 'puma'
gem 'sinatra'
gem 'sinatra-contrib'
gem 'oga' # shouldn't be needed since they are in queenshop
gem 'iconv' # same as above, but won't work if not included
gem 'queenshop'
gem 'json'

gem 'activesupport'

gem 'config_env'
gem 'aws-sdk', '~> 2'     # DynamoDB (Dynamoid), SQS Message Queue
gem 'dynamoid', '~> 1'
gem 'dalli'               # Memcachier

group :development do
    gem 'tux'
end

group :test do
  gem 'minitest'
  gem 'minitest-rg'
  gem 'rack'
  gem 'rack-test'
  gem 'rake'
end

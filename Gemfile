source 'http://rubygems.org'
# ruby '2.2.0'

gem 'puma'
gem 'sinatra', require: 'sinatra/base'
gem "sinatra-cross_origin", "~> 0.3.1"
gem 'rack-cors', :require => 'rack/cors'
gem 'sinatra-contrib', '1.3.1'
gem 'oga' # shouldn't be needed since they are in queenshop
gem 'iconv' # same as above, but won't work if not included
gem 'queenshop'
gem 'joyceshop'
gem 'stylemooncat'
gem 'json'

gem 'activesupport'
gem 'concurrent-ruby-ext'

gem 'config_env'
gem 'aws-sdk', '~> 2'     # DynamoDB (Dynamoid), SQS Message Queue
gem 'dynamoid', '~> 1'
gem 'dalli'               # Memcachier

group :development do
    gem 'tux'
end

group :development, :test do
  gem 'vcr'
  gem 'webmock'
end

group :test do
  gem 'minitest'
  gem 'minitest-rg'
  gem 'rack'
  gem 'rack-test'
  gem 'rake'
end

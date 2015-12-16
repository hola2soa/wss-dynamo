ENV['RACK_ENV'] = 'test'

require ::File.expand_path('../../config/environments', __FILE__)
require 'minitest/autorun'
require 'minitest/rg'
require 'rack/test'
require 'vcr'
require 'bundler/setup'
require 'webmock/minitest'
require 'yaml'

include Rack::Test::Methods

def app
  SinatraApp
end

def random_str(n)
  srand(n)
  (0..n).map { ('a'..'z').to_a[rand(26)] }.join
end

VCR.configure do |config|
  config.allow_http_connections_when_no_cassette = true
  config.cassette_library_dir = 'spec/fixtures/cassette'
  config.hook_into :webmock
end

def load_yml(file_path)
  YAML.load(File.read(file_path))
end

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

# params file => parameters hash
PASSED_TESTS = {'page1'=> {pages: '1'}}
FAIL_TEST = ['mmjjhii33.99023j9893'] # will do later to call random

def app
  SinatraApp
end

def random_str(n)
  srand(n)
  (0..n).map { ('a'..'z').to_a[rand(26)] }.join
end

VCR.configure do |config|
	config.cassette_library_dir = 'spec/fixtures/cassette'
  config.hook_into :webmock
end

def load_yml(file_path)
	YAML.load(File.read(file_path))
end



#!/usr/bin/env ruby
ENV['RACK_ENV'] = 'test'

require 'bundler/setup'
require 'sinatra/base'
require 'minitest/autorun'
require 'rack/test'
require_relative '../app'

include Rack::Test::Methods

def app
  QueenShopApi::SinatraApp
end

def random_str(n)
  srand(n)
  (0..n).map { ('a'..'z').to_a[rand(26)] }.join
end

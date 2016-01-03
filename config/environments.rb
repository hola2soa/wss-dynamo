require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/namespace'
require 'sinatra/json'

require_relative 'database'

# load files in this specific order
Dir.glob('./app/{helpers,models,services}/*.rb').each { |file| require file }

# then load controllers
Dir.glob('./app/controllers/*/*.rb').each { |file| require file }

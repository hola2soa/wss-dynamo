require 'sinatra/base'
require 'sinatra/json'

# Ensure app.rb gets loaded before all routes
require_relative '../app'

# Load up api files
paths = [
  'models',
  'helpers', # helpers should come before routes because the later relies on the first
  'routes',
]

paths.each do |path|
  Dir[File.dirname(__FILE__) + "/../app/#{path}/*.rb"].each do |file|
    require file 
  end
end
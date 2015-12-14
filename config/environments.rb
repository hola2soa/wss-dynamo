require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/namespace'
require 'sinatra/json'

require 'dynamoid'
require 'aws-sdk'
require 'config_env'

require_relative 'database'

# Ensure app.rb gets loaded before all routes
require File.expand_path('../../app', __FILE__)

# Require routes.rb
require File.expand_path('../routes', __FILE__)

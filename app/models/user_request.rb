require 'sinatra'
require 'sinatra/activerecord'
require_relative '../../config/db_environment'

class Request < ActiveRecord::Base
end

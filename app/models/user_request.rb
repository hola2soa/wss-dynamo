require 'sinatra'
require 'sinatra/activerecord'
require_relative '../../config/db_environment'

class UserRequest < ActiveRecord::Base
end

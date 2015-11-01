#!/usr/bin/env ruby
require 'sinatra/base'
module QueenShopApi
class SinatraApp < Sinatra::Base
  # Standard Sinatra configurations
  configure :production, :development do
    enable :logging
  end
end
end

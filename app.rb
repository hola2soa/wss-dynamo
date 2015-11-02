#!/usr/bin/env ruby
require 'sinatra/base'
# only for test now
# will remove shortly
#require_relative('./app/models/products')
#require_relative('./app/helpers/queen_shop')
##

module QueenShopApi
class SinatraApp < Sinatra::Base
  # Standard Sinatra configurations
  configure :production, :development do
    enable :logging
  end

end
end

#!/usr/bin/env ruby
module QueenShopApi
class SinatraApp < Sinatra::Base
  # Standard Sinatra configurations
  configure :production, :development do
    enable :loggin
  end
end
end

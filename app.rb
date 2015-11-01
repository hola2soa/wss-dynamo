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
    get '/' do
      'Queenshop is up and working. See documentation at its ' \
        '<a href="https://github.com/hola2soa/QueenShopWebApi">' \
        'Github repo - master branch</a>'
    end
# =begin		
		post '/happy' do
			content_type :json
    	begin
      	req = JSON.parse(request.body.read)
    	rescue => e
      	logger.error "Error: #{e.message}"
      	halt 400
    	end
    	check_items(req['items'], req['prices'], req['pages']).to_json
		end
# =end
  end

end
end

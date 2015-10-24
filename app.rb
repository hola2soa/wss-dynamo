require 'sinatra/base'
require_relative './model/products'

##
# Basic webapp to show queenshop item/prices
class QueenShopApp < Sinatra::Base
  helpers do
    def get_items(params)
      Products.new(params)
    rescue
      halt 404
    end

    def check_items (items, prices, pages)
      items.map do |item|
        found = Products.new(item, '', pages).products.keys
        [item, prices.select { |price| !found.include? price }]
      end.to_h
    rescue
      halt 404
    end
  end

  get '/' do
    'Queenshop is up and working. See documentation at its ' \
      '<a href="https://github.com/hola2soa/QueenShopWebApi">' \
      'Github repo - master branch</a>'
  end

  get '/api/v1/cadet/:item.json' do
    content_type :json
    get_items(params[:item]).to_json
  end

  post '/api/v1/check' do
    content_type :json
    begin
      req = JSON.parse(request.body.read)
    rescue
      halt 400
    end

    check_items(req['items'], req['prices'], req['pages']).to_json
  end
end

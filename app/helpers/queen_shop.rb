module QueenShopApi
class SinatraApp < Sinatra::Base
  helpers do
    def get_items(params)
      Products.new(params).products
    rescue
      halt 404
    end

    def check_items (items, prices, pages)
      items.map do |item|
        found = Products.new(item, '', pages).prices
        [item, prices.select { |price| found.include? price.to_s }]
      end.to_h
      rescue
        halt 404
    end
  end
end
end

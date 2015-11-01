module QueenShopApi
class SinatraApp < Sinatra::Base

  get '/' do
    'Queenshop is up and working. See documentation at its ' \
      '<a href="https://github.com/hola2soa/QueenShopWebApi">' \
      'Github repo - master branch</a>'
  end
  
  get '/qs/:item' do
    content_type :json
    get_items(params[:item]).to_json
  end

  post '/check' do
    content_type :json
    begin
      req = JSON.parse(request.body.read)
    rescue => e
      logger.error "Error: #{e.message}"
      halt 400
    end

    check_items(req['items'], req['prices'], req['pages']).to_json
  end

end
end

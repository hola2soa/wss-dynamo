class SinatraApp < Sinatra::Base
  helpers BaseHelper
  helpers ScraperHelper

  configure :production, :development do
    enable :logging
  end

  create_user_request = lambda do
    content_type :json
    begin
      req = JSON.parse(request.body.read)
      logger.info req
    rescue => e
      logger.error "Error: #{e.message}"
      halt 400
    end

    user_request = new_user_request(req)
    if user_request.save
      redirect "/api/v1?id=#{user_request.id}", 303
    else
      logger.error 'Error saving request to database'
      halt 500, 'Error saving request request to the database'
    end
  end

  delete_item = lambda do
    halt 400, 'invalid parameter' unless params[:id]
    deleted = UserRequest.destroy(params[:id])
    status(deleted > 0 ? 200 : 404)
  end

  root = lambda do
    'hola2soa API for three women online shopping scrapers'
  end

  handle_get_api_request = lambda do
    content_type :json
    options = parse_uri(params)
    fetch_records(options)
  end

  get '/', &root
  get '/api/v1/?', &handle_get_api_request
  post '/api/v1/?', &create_user_request
  delete '/api/v1?', &delete_item
end

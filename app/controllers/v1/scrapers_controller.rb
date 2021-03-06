class SinatraApp < Sinatra::Base
  helpers BaseHelper
  helpers ScraperHelper
  helpers UserHelper

  create_user_request = lambda do
    content_type :json
    # authorize!

    begin
      req = JSON.parse(request.body.read)
    rescue => e
      logger.error "Error: #{e.message}"
      halt 400
    end

    user_request = new_user_request(req)
    url = "#{settings.api_server}/api/v1/item?id=#{user_request.id}"
    { url: url, channel_id: session[:channel_id] }.to_json
  end

  get_items_by_id = lambda do
    content_type :json
    halt 400, 'Invalid Id' unless params[:id]
    get_items_by_id(params[:id])
  end

  delete_item = lambda do
    # authorize!
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
    fetch_item_records(options)
  end

  scrape_single_page = lambda do
    content_type :json
    options = parse_uri(params)
    scrape_single_page(options)
  end

  random_items = lambda do
    content_type :json
    get_random_items(params).to_json
  end

  get_user_pinned_items = lambda do
    content_type :json
    # authorize!
    req = JSON.parse(request.body.read)
    get_user_pinned_items(req).to_json
  end

  stores_daily_pinned_items = lambda do
    content_type :json
    stores_daily_pinned_items().to_json
  end

  get '/', &root
  get '/api/v1?', &handle_get_api_request
  get '/api/v1/ssp?', &scrape_single_page
  get '/api/v1/random_items', &random_items
  get '/api/v1/stores_daily_pinned_items', &stores_daily_pinned_items
  post '/api/v1/user_pinned_items', &get_user_pinned_items
  post '/api/v1/get_items', &create_user_request
  get '/api/v1/item?', &get_items_by_id
  delete '/api/v1?', &delete_item
end

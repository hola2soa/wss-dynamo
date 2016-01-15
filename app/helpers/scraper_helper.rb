require 'concurrent'

module ScraperHelper
  def fetch_item_records(opts)
    #items = settings.wss_cache.fetch(opts.to_s, ttl=settings.wss_cache_ttl) do
      items = ScrapeItems.new.call(opts).tap { |v| encache_var opts.to_s, v }
    #end
    items.nil? ? halt(404) : items.to_json
  end

  def get_items_by_id(id)
    check_items(id)
    { url: url, channel_id: session[:channel_id] }.to_json
  end

  def scrape_single_page(opts)
    halt 400, 'No page provided' unless opts[:page]
    halt 400, 'Invalid page parameter' unless opts[:page].to_i != 0
    items = settings.wss_cache.fetch(opts.to_s, ttl=settings.wss_cache_ttl) do
      ScrapeItems.new.scrape_single_page(opts).tap { |v| encache_var opts.to_s, v }
    end
    opts = nil
    items.nil? ? halt(404) : items.to_json
  end

  def check_items(item_id)
    channel_id = session[:channel_id] || rand.hash
    session[:channel_id] = channel_id
    email_address = session[:email_address] || 'ted@gmail.com'

    begin
      user_request = UserRequest.find(item_id)
      raise 'item not found' unless user_request
    rescue => e
      logger.error "Error while fetching request from database #{e.message}"
      halt 404, 'User request record not found'
    end

    user_stores = get_user_stores(email_address)
    halt 400, 'User has no store in preferences' unless user_stores

    # options = { id: user_request.id, channel_id: channel_id, store: user_stores }.to_json
    res = []
    res = user_request.result.flatten.compact.uniq if user_request.result
    res
  end

  def get_random_items(req)
    if req['random']
      halt 400, 'invalid number of requested items' if req['random'].to_i == 0
    end

    count = req['random'].to_i || 5
    items = []
    1.upto(3) { items << scrape_random_page }
    items = items.flatten.compact.uniq
    items.sample(count)
  end

  def scrape_random_page
    store = ['queenshop', 'stylemooncat'].sample
    category = ['latest', 'popular', 'tops', 'pants', 'accessories', 'search'].sample
    page = (1..5).to_a.sample
    opts = { store: store, category: category, page: page }
    ScrapeItems.new.scrape_single_page(opts)
  end

  def get_user_pinned_items(req)
    # email_address = session[:email_address]
    email_address = req['email_address'] || 'ted@gmail.com'
    pinned = email_address.split("@")[0]
    settings.wss_cache.fetch(pinned, ttl=settings.wss_cache_ttl) do
      GetUserPinnedItems.new.call(email_address).tap { |v| encache_var pinned, v }
    end
  end
end

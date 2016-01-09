require 'concurrent'

module ScraperHelper
  def fetch_item_records(opts)
    items = check_items(opts[:id]) if opts[:id]
    items = ScrapeItems.new.call(opts) unless opts[:id]
    items.nil? ? halt(404) : items.to_json
  end

  def scrape_single_page(opts)
    halt 400, 'No page provided' unless opts[:page]
    halt 400, 'Invalid page parameter' unless opts[:page].to_i != 0
    items = ScrapeItems.new.scrape_single_page(opts)
    items.nil? ? halt(404) : items.to_json
  end

  def check_items(item_id)
    begin
      user_request = UserRequest.find(item_id)
      raise 'item not found' unless user_request
    rescue => e
      logger.error "Error while fetching request from database #{e.message}"
      halt 404, 'User request record not found'
    end

    begin
      keywords = user_request.keywords
      prices = user_request.prices
      categories = user_request.categories
      options = formulate_options(keywords, prices, categories)
      items = []

      if !options.empty?
        items = ScrapeMultipleItems.new.call(options)
      else
        halt 500, 'Unexpected error occcured'
      end
    rescue => e
      halt 400, 'Failed to scrape multiple items'
    end
    items
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

  def get_user_pinned_items
    email_address = 'ted@gmail.com'#session[:email_address]
    GetUserPinnedItems.new.call(email_address)
  end

  def formulate_options(keywords, prices, categories)
    kw = keywords.map { |value| { keyword: value } } if keywords
    pr = prices.map { |value| { price_boundary: value } } if prices
    ca = categories.map { |value| { category: value } } if categories

    user_stores = GetUserStores.new.call(session[:email_address])
    halt 400, 'User has no stores' unless user_stores
    stores = user_stores.map { |value| { store: value } }

    result = [], *options = []
    options.push(kw) if kw
    options.push(pr) if pr
    options.push(ca) if ca
    options.push(stores)
    if options.length >= 1
      r = options[0]
      r.product(*options).each { |i| result.push(i.reduce({}, :merge)) }
    end
    result
  end
end

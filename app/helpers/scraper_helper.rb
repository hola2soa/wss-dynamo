require 'concurrent'
module ScraperHelper
  def fetch_item_records(opts)
    puts "[[[[[[[[[[[[[[]]]]]]]]]]]]]]#{opts}"
    items = check_items(opts[:id]) if opts[:id]
    items = ScrapeItems.new.call(opts) unless opts[:id]
    items.empty? ? halt(404) : items.to_json
  end

  def check_items(item_id)
    puts "----------------------------------#{item_id}"
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

      results = CheckMultipleItems.new.call(options)
    rescue => e
      halt 400
    end
    # item
  end

  def formulate_options(keywords, prices, categories)
    kw = Hash[keywords.map {|value| ["keyword", value]}]
    pr = Hash[prices.map {|value| ["price_boundary", value]}]
    ca = Hash[categories.map {|value| ["category", value]}]
    options = [kw, pr, ca]
    options.inject(&:product).map(&:flatten)
  end
end

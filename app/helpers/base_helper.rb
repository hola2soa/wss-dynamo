module BaseHelper
  @@stores      = ['queenshop', 'joyceshop', 'stylemooncat']
  @@categories  = ['latest', 'popular', 'tops', 'pants', 'accessories', 'search']
  @@params  = {}

  def parse_uri(uri)
    read_params(uri)
    @@params
  end

  def read_params(uri)
    # should get store from logged in user instead of params
    keyword = URI.decode(uri[:keyword]) if uri[:keyword]
    @@params[:store] = uri[:store] || nil
    @@params[:category] = uri[:category] || 'search'
    @@params[:keyword] = keyword || ''
    @@params[:page_limit] = uri[:page_limit] || 3
    @@params[:page] = uri[:page] || 1 # to scrape single page
    @@params[:price_boundary] = parse_price(uri[:price]) if uri[:price]

    # if !@@params[:id]
    #   halt 404 unless @@stores.include? @@params[:store]
    # end
  end

  def stores_daily_pinned_items
    StoresDailyPinnedItems.new.call()
  end

  def parse_price(price)
    pr = price.split(',').map(&:to_i)

    pr.push(pr[0].to_i) if pr.length == 1
    pr = [0, 9999999] unless pr.all? { |i| i.is_a? Numeric }
    pr
  end

  def failed(message)
    {status: 'failed', message: message}
  end

  def passed(data, message)
    {status: 'passed',  data: data, message: message}
  end
end

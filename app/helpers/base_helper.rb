module BaseHelper
  @@stores      = ['queenshop', 'joyceshop', 'stylemooncat']
  @@categories  = ['latest', 'popular', 'tops', 'pants', 'accessories']
  @@params  = {}

  def parse_uri(uri)
    read_params(uri)
    @@params
  end

  def read_params(uri)
    @@params[:store] = uri[:store] || nil
    @@params[:category] = uri[:category] || 'search'
    @@params[:id] = uri[:id] if uri[:id]
    @@params[:keyword] = uri[:keyword] || ''
    @@params[:page_limit] = uri[:page_limit] || 3
    @@params[:price] = parse_price(uri[:price]) if uri[:price]

    halt 404 unless @@stores.include? @@params[:store]
  end

  def fetch_records(options)
    items = check_items(options[:id]) if options[:id]
    items = GetItems.new.call(options) unless options[:id]
    items.empty? ? halt(404) : items.to_json
  end

  def parse_price(price)
    pr = price.split(',')
    pr.push(pr[0]) if pr.length == 1
    halt 400, 'invalid price'.to_json unless pr.all? { |i| i.is_a? Numeric }
    pr
  end
end

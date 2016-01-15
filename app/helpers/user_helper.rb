module UserHelper
  def authenticate_user(email_address, stores = ['queenshop', 'joyceshop', 'stylemooncat'])
    halt 400, 'Stores expected array' unless stores.kind_of?(Array)
    valid_email(email_address)
    user = AuthenticateUser.new.call(email_address)
    user = create_user(email_address, stores) if user.nil?
    user
  end

  def create_user(req)
    logger.info '----> prepare to create a new user'
    logger.info req
    email_address = req['email_address'] || nil
    name          = req['name'] || ''
    stores        = req['stores'] || []
    valid_stores(stores)
    logger.info '----> stores valid'
    valid_email(email_address)
    logger.info '----> email valid'
    user = get_user(email_address)
    logger.info '----> check if user existed'
    logger.info user
    halt 400, 'User already exists' unless user.nil?
    logger.info '----> user is not existed, create!'
    CreateUser.new.call(email_address, name, stores)
  end

  def add_user_stores(req)
    email_address = session[:email_address] || nil
    name = req['name'] || nil
    stores = req['stores'] || ['queenshop', 'joyceshop', 'stylemooncat']
    valid_email(email_address)
    valid_stores(stores)
    error_invalid_user(email_address)
    UpdateUser.new.add_stores(email_address, name, stores)
  end

  def remove_user_stores(req)
    email_address = session[:email_address] || 'ted@gmail.com'
    stores = req['stores']
    valid_stores(stores)
    error_invalid_user(email_address)
    UpdateUser.new.remove_stores(email_address, stores)
  end

  def new_user_request(req)
    channel_id = session[:channel_id] || rand.hash
    session[:channel_id] = channel_id
    keywords = check_keywords(req)
    prices = check_prices(req)
    categories = check_categories(req)
    email_address = session[:email_address] || 'ted@gmail.com'
    valid_email(email_address)
    res = []
    record = { keywords: keywords, prices: prices, categories: categories, results: res }
    user_req = SaveUserRequest.new.call(email_address, record)
    halt 500, 'Unable to save request to database' if user_req.nil?

    user_stores = get_user_stores(email_address)
    halt 400, 'User has no store in preferences' unless !user_stores.empty?

    options = { id: user_req.id, channel_id: channel_id, stores: user_stores }.to_json
    ScraperWorker.perform_async(options)
    user_req
  end

  def authorized?
    session[:authorized]
  end

  def authorize!
    halt 503, 'Please login to access resource' unless authorized?
  end

  def authorize(req)
    logger.info '----> prepare to auth user'
    halt 400, 'please provide email address' unless req['email_address']
    email_address = req['email_address']
    logger.info email_address
    user = User.find_by_email_address(email_address)
    halt 404, 'mismatch credentials' unless user

    session[:authorized] = true
    session[:stores] = GetUserStores.new.call(email_address)
    session[:email_address] = user.email_address

    {
      authorized: true,
      user: {
        name:          user.name,
        email_address: user.email_address,
        stores: session[:stores]
      }
    }
  end

  def logout!
    session.clear
  end

  def check_keywords(req)
    halt 400, 'no keywords in input' unless req['keywords']
    keywords = URI.decode(req['keywords'])
    keywords = keywords.split(/\n/) if keywords.is_a? String
    halt 400, 'Keywords must be an array' unless keywords.kind_of? Array
    keywords
  end

  def check_prices(req)
    prices = []
    if req['prices']
      prices = req['prices']
      prices = prices.split("\n").map { |i| i.split(",") } if prices.is_a? String
      halt 400, 'Prices must be an array' unless prices.kind_of? Array
    end
      prices
  end

  def check_categories(req)
    categories = ['search']
    if req['categories']
      cat = req['categories']
      cat = cat.split("\n") if cat.is_a? String
      halt 400, 'Categories must be an array' unless prices.kind_of? Array
    end
      categories
  end

  def valid_email(email_address)
    reg = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
    halt 400, 'Invalid email address' if (email_address =~ reg).nil?
  end

  def valid_stores(stores)
    halt 400, 'No stores supplied' if stores.nil?
    halt 400, 'Stores expected to be array' unless stores.kind_of?(Array)
  end

  def get_user(email_address)
    logger.info '----> getting user....'
    User.find_by_email_address(email_address)
  end

  def error_invalid_user(email_address)
    user = get_user(email_address)
    halt 400, 'User not found' unless user
  end

  def get_user_stores(email_address)
    GetUserStores.new.call(email_address)
  end

  def encache_var(var, val)
    settings.wss_cache.set(var, val, ttl=settings.wss_cache_ttl)
  rescue => e
    logger.info "ENCACHE failed: #{e}"
  end
end

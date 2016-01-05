module UserHelper
  def authenticate_user(email_address, stores = ['queenshop', 'joyceshop', 'stylemooncat'])
    halt 400, 'Stores expected array' unless stores.kind_of?(Array)
    valid_email(email_address)
    user = AuthenticateUser.new.call(email_address)
    user = create_user(email_address, stores) if user.nil?
    user
  end

  def create_user(req)
    email_address = req['email_address'] || nil
    stores = req['stores'] || []
    valid_stores(stores)
    valid_email(email_address)
    user = get_user(email_address)
    halt 400, 'User already exists' unless user.nil?
    CreateUser.new.call(email_address, stores)
  end

  def add_user_stores(req)
    email_address = req['email_address'] || nil
    stores = req['stores'] || ['queenshop', 'joyceshop', 'stylemooncat']
    valid_email(email_address)
    valid_stores(stores)
    error_invalid_user(email_address)
    UpdateUser.new.add_stores(email_address, stores)
  end

  def remove_user_stores(req)
    email_address = req['email_address'] || nil
    stores = req['stores']
    valid_stores(stores)
    error_invalid_user(email_address)
    UpdateUser.new.remove_stores(email_address, stores)
  end

  def new_user_request(req)
    # only users logged in allowed to search??
    # if not then force to pass an email address
    keywords = check_keywords(req)
    prices = check_prices(req)
    categories = check_categories(req)
    email_address = req['email_address'] || nil
    valid_email(email_address)
    record = { keywords: keywords, prices: prices, categories: categories }
    puts '-----------------------------------------------------------------'
    puts record
    user_req = SaveUserRequest.new.call(email_address, record)
    halt 500, 'Unable to save request to database' if user_req.nil?
    user_req
  end

  def check_keywords(req)
    halt 400, 'no keywords in input' unless req['keywords']
    keywords = req['keywords']
    keywords = keywords.split(/\n/) if keywords.is_a? String
    halt 400, 'Keywords must be an array' unless keywords.kind_of? Array
    keywords
  end

  def check_prices(req)
    prices = []
    if req['prices']
      prices = req['prices']
      prices = prices.split("\n").map { |i| i.split(",") } if pr.is_a? String
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
    User.find_by_email_address(email_address)
  end

  def error_invalid_user(email_address)
    user = get_user(email_address)
    halt 400, 'User not found' unless user
  end
end
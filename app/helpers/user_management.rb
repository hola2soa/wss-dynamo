module UserManagement
  def authenticate_user(email_address, stores = ['queenshop', 'joyceshop', 'stylemooncat'])
    halt 400, 'Stores expected array' if stores.kind_of?(Array)
    valid_email(email_address)
    user = AuthenticateUser.new.call(email_address)
    user = create_user(email_address, stores) if user.nil?
    user
  end

  def create_user(email_address, stores = ['queenshop', 'joyceshop', 'stylemooncat'])
    halt 400, 'Stores expected array' if stores.kind_of?(Array)
    valid_email(email_address)
    CreateUser.new.call(email_address, stores)
  end

  def add_user_stores(email_address, stores)
    valid_email(email_address)
    UpdateUser.new.add_stores(email_address, stores)
  end

  def delete_user_stores(email_address, stores)
    halt 400, 'Stores expected array' if stores.kind_of?(Array)
    UpdateUser.new.remove_stores(email_address, stores)
  end

  def valid_email(email_address)
    email_address =~ /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
    halt 400, 'Invalid email address' if email_address.nil?
  end
end

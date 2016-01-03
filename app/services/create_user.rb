class CreateUser
  def call(email_address, stores = [])
    user = User.new
    user.email_address = email_address
    stores.each do |store|
      user.store_preferences.build(store)
    end
    user.save
    user
  end
end

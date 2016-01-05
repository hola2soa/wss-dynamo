class CreateUser
  def call(email_address, name, stores = [])
    begin
      user = User.new
      user.email_address = email_address
      user.name = name
      user.save # need to save parent before creating association
      stores.each do |store_name|
        store = GetCreateStore.new.call(store_name)
        user.stores << store
      end
    rescue Exception
      User.find(user.id).destroy if user # remove user since there was an error
      { success: false, message: 'failed to create user' }
    end
    { success: true, data: user, message: 'user created successfully' }
  end
end

class UpdateUser
  def remove_stores(email_address, stores)
    user = User.find_by_email_address(email_address)
    halt 404, 'user not found' if user.nil?

    stores.each do |store_name|
      store = user.store_preferences.find_by_name(store_name)
      user.store_preferences.delete(store)
    end
    user.save
  end

  def add_stores(email_address, stores)
    user = User.find_by_email_address(email_address)
    halt 404, 'user not found' if user.nil?

    stores.each do |store_name|
      user.store_preferences.build({name: store})
    end
    user.save
  end

  def pin_item(email_address, item)
    user = User.find_by_email_address(email_address)
    halt 404, 'user not found' if user.nil?

    # check if item exist
    exist = user.pinned_items.find_by_link(item[:link])
    if exist.nil?
      user.pinned_items.build(item)
      user.save
    end
  end

  def unpin_item(email_address, item)
    user = User.find_by_email_address(email_address)
    halt 404, 'user not found' if user.nil?

    # check if item exist
    exist = user.pinned_items.find_by_link(item[:link])
    halt 404, 'user never pinned this item' if exist.nil?
    user.pinned_items.delete(exist)
  end
end

class UpdateUser
  def remove_stores(email_address, stores)
    user = User.find_by_email_address(email_address)
    stores.each do |store_name|
      store = GetCreateStore.new.call(store_name)
      user.stores.delete(store)
    end
    { success: true, message: 'stores removed from user preferences' }
  end

  def add_stores(email_address, stores)
    begin
      user = User.find_by_email_address(email_address)
      stores.each do |store_name|
        store = GetCreateStore.new.call(store_name)
        user.stores << store
      end
    rescue Exception
      { success: false, message: 'Error adding stores to user preferences' }
    end
    { success: true, message: 'stores added successfully to user preferences' }
  end

  def pin_item(user, item_h, store_name)
    begin
      item = GetCreateItem.new.call(item_h, store_name)
      user.items << item
    rescue Exception
      puts 'noooo'
      { success: false, message: 'Failed to pin item' }
    end
    { success: true, message: 'Item pinned successfully' }
  end

  def unpin_item(user, item_h, store_name)
    begin
      item = GetCreateItem.new.call(item_h, store_name)
      user.items.delete(item)
    rescue Exception
      { success: false, message: 'Failed to unpin item' }
    end
    { success: true, message: 'Item unpinned successfully' }
  end
end

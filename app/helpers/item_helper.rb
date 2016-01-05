module ItemHelper
  def pin_item(req)
    email_address = req['email_address'] || nil
    item = req['item'] || {}

    valid_email(email_address)
    user = get_user(email_address)
    halt 400, 'User does not exist' unless user
    store_name = get_store_from_link(item['link'])
    UpdateUser.new.pin_item(user, item, store_name)
  end

  def unpin_item(req)
    email_address = req['email_address'] || nil
    item = req['item'] || {}

    valid_email(email_address)
    user = get_user(email_address)
    halt 400, 'User does not exist' unless user
    store_name = get_store_from_link(item['link'])
    UpdateUser.new.unpin_item(user, item, store_name)
  end


  def get_store_from_link(url)
    begin
      url.split(/\./)[0].split(/\/\//)[1]
    rescue Exception
      halt 400, 'could not get store name'
    end
  end
end

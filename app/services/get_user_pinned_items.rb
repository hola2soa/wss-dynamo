class GetUserPinnedItems
  def call(email_address)
    user = User.find_by_email_address(email_address)
    item = user.items.flat_map do |u|
      store = user.items.flat_map { |u| u.store.attributes.select{ |x| x['name'] }.values }
      store = store.join
      { title: u.title, price: u.price, image: u.images, link: u.link, store: store }
    end
    item[0]
  end
end

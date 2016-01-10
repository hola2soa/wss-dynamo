class StoresDailyPinnedItems
  def call()
    users = User.all
    users.each do |user|
      user.items.flat_map do |i|
        store = string_store(i)
        { store: store }
      end
    end
  end

  def string_store(item)
    store = item.flat_map do |u|
      v = u.store.attributes.select { |x| x['name'] }.values
      v.join
    end
  end
end

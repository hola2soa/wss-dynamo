class GetCreateStore
  def call(store_name)
    store = Store.find_by_name(store_name)
    if store.nil?
      store = Store.new
      store.name = store_name
      store.save
    end
    store
  end
end

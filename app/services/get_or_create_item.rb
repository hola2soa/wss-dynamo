class GetCreateItem
  def call(item, store_name)
    the_item = Item.find_by_link(item['link'])
    
    if the_item.nil?
      store = GetCreateStore.new.call(store_name)
      the_item = Item.new(item)
      the_item.store = store
      the_item.save
    end
    the_item
  end
end

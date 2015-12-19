require 'concurrent'
module QueenshopHelper
  def new_item(req)
    item = Item.new
    item.items = req['items']
    item.prices = req['prices']
    item.pages = req['pages']
    item
  end

  def check_items(item_id)
    begin
      item = Item.find(item_id)
      items = JSON.parse(item.items)
      prices = JSON.parse(item.prices)
      pages = item.pages
    rescue => e
      logger.error "Error while fetching request from database #{e.message}"
      halt 400
    end

    CheckMultipleItems.new.call(items, prices, pages)
  rescue => e
    logger.info e
    halt 404
  end
end

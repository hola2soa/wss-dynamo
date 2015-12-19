require_relative './get_items'

class CheckMultipleItems
  def call(items, prices, pages)
    found_prices = []
    notfound = []

    threads = Concurrent::CachedThreadPool.new
    items.each do |item|
      threads.post do
        begin
          found_prices[item] = GetItems.new.call(item, '', pages)["all_prices"]
        rescue
          notfound << item
        end
      end
    end
    threads.shutdown
    threads.wait_for_termination
    found_prices
  rescue => e
    raise Exception.new("Error checking multiple items: #{e}")
  end
end

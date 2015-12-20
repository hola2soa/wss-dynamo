require_relative './get_items'

class CheckMultipleItems
  def call(items, prices, pages)
    found_prices = {}
    notfound = []

    threads = Concurrent::CachedThreadPool.new
    items.each do |item|
      threads.post do
        begin
          all_prices = GetItems.new.call(item)[:all_prices]
          found_prices[item] = prices.select{ |p| all_prices.include? p.to_s }
        rescue
          notfound << item
        end
      end
    end

    threads.shutdown
    threads.wait_for_termination

    raise 'prices for items not found' unless !all_elements_empty? found_prices
    found_prices
  rescue => e
    raise "Error checking multiple items: #{e}"
  end

  private

  def all_elements_empty?(arr)
    n = 0
    arr.each { |k, v| puts v.empty?; n += 1 if v.empty? }
    n == arr.length
  end
end

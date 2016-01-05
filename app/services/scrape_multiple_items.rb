require_relative './get_or_create_item'

class ScrapeMultipleItems
  def call(options)
    threads = Concurrent::CachedThreadPool.new
    records = []
    notfound = []
    options.each do |option|
      threads.post do
        begin
          records << ScrapeItems.new.call(option)
        rescue
          notfound << option
        end
      end
    end
    threads.shutdown
    threads.wait_for_termination
    { result: records.flatten.compact.uniq, notfound: notfound }
  end
end

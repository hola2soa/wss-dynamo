require 'concurrent'
module ScraperHelper
  def new_user_request(req)
    ur = UserRequest.new
    ur.keywords = Marshal.dump(req['keywords'].split("\n"))
    ur.prices = Marshal.dump(req['prices'].split("\n").map { |i| i.split(",") })
    ur
  end

  def check_items(item_id)
    begin
      ur = UserRequest.find(item_id)
      raise 'not item found' unless !ur.nil?
    rescue => e
      logger.error "Error while fetching request from database #{e.message}"
      halt 404
    end

    begin
      items = Marshal.load(ur.items)
      prices = Marshal.load(ur.prices)

      results = CheckMultipleItems.new.call(items, prices)
    rescue => e
      halt 400
    end
    # item
  end
end

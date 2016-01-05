require 'queenshop'

# Service object to check tutorial request from API
class ScrapeItems
  def call(options)
    halt 400, 'no store defined' unless options[:store]
    scrape_items(options)
  end

  private

  def scrape_items(options)
    scraper = instatiate_shop_scraper(options[:store])
    scraper.scrape(options[:category], options)
  end

  def instatiate_shop_scraper(shop)
    scraper = ''
    case shop
    when 'queenshop'
      scraper = QueenShop::Scraper.new
    when 'joyceshop'
      scraper = JoyceShop::Scraper.new
    when 'stylemooncat'
      scraper = StyleMoonCat::Scraper.new
    else
      'invalid shop (no scraper supported)'
      halt 400 # bad request
    end
    scraper
  end
end

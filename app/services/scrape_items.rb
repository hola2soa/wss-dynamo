require 'queenshop'
require 'joyceshop'
require 'stylemooncat'

# Service object to check tutorial request from API
class ScrapeItems
  def call(options)
    if options[:store]
      scrape_items(options)
    else
      'No store specified'
    end
  end

  def scrape_single_page(options)
    if options[:store]
      scrape_page(options)
    else
      'No store specified'
    end
  end

  private

  def scrape_items(options)
    scraper = instatiate_shop_scraper(options[:store])
    scraper.scrape(options[:category], options).flatten.compact.uniq
  end

  def scrape_page(options)
    page = options[:page].to_i
    opts = options.slice('price', 'keyword')

    scraper = instatiate_shop_scraper(options[:store])
    method = scraper.method(options[:category])
    method.call(page, opts).flatten.compact.uniq
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
      abort 'invalid shop (no scraper supported)'
    end
    scraper
  end
end

require 'queenshop'

# Service object to check tutorial request from API
class GetItems
  def call(item_name, prices = '', pages = '')
    return nil unless item_name
    params = build_params(item_name, prices, pages)
    items = scrape_items(params)
    all_prices = items.map {|row| row[:price]}
    { 'items': items, 'all_prices': all_prices }
  end

  private

  def scrape_items(params)
    scraper = QueenShopScraper::Filter.new
    scraper.scrape(params)
  end

  def build_params(item_name = '', price = '', pages = '')
    params = []
    puts "--------------------->#{price}"

    params.push("price=#{price}") if !price.empty?
    params.push("item=#{item_name}") if !item_name.empty?
    params.push("pages=#{pages}") if !pages.empty?
    params
  end

end

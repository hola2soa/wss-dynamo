require_relative '../helpers/base_helper'
require_relative '../models/user_request'
require_relative '../services/scrape_items'
require_relative '../../config/database'
require 'json'
require 'config_env'
require 'httparty'
require 'shoryuken'

env_file = "#{__dir__}/../config/config_env.rb"
ConfigEnv.path_to_config(env_file) unless ENV['AWS_REGION']

class ScraperWorker
  include Shoryuken::Worker
  include BaseHelper

  shoryuken_options queue: 'RecentRequests', auto_delete: true
  shoryuken_options body_parser: JSON

  def initialize()
    @task_count = 9
    @progress = 0
  end

  def perform(sqs_msg, body)
    id = body['id']
    channel_id = body['channel_id']
    stores = body['stores']

    user_request = UserRequest.find(id)
    keywords = user_request.keywords
    prices = user_request.prices
    categories = user_request.categories
    options = formulate_options(keywords, prices, categories, stores)
    @task_count = options.length
    options.each do |option|
      result = ScrapeItems.new.call(option) if !option.empty?
      update_progress(channel_id, result)
    end
  end

  private

  def update_progress(channel_id, data)
    percent = (@progress += (100/@task_count)).to_s
    message = { data: data, progress: percent }
    publish(channel_id, message)
  end

  def publish(channel, message)
    HTTParty.post('http://localhost:9292/faye', {
        :headers  => { 'Content-Type' => 'application/json' },
        :body    => {
            channel: "/#{channel}",
            data: message
        }.to_json
    })
  end

  def formulate_options(keywords, prices, categories, stores)
    kw = keywords.map { |value| { keyword: value } } if keywords
    pr = prices.map { |value| { price_boundary: value } } if prices
    ca = categories.map { |value| { category: value } } if categories
    st = stores.map { |value| { store: value } }

    result = [], *options = []
    options.push(kw) if kw
    options.push(pr) if pr
    options.push(ca) if ca
    options.push(st)

    if options.length >= 1
      r = options[0]
      r.product(*options).each { |i| result.push(i.reduce({}, :merge)) }
    end
    result
  end
end

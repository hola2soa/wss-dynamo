require_relative '../../config/environments'
require 'shoryuken'

class ScraperWorker
  include Shoryuken::Worker
  shoryuken_options queue: 'RecentRequests', auto_delete: true, body_parser: :json

  def perform(sqs_msg, options)
  end
end
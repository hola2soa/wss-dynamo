require 'rake/testtask'
require 'config_env/rake_tasks'

require ::File.expand_path('../config/environments', __FILE__)

task :config do
  ConfigEnv.path_to_config("#{__dir__}/config/config_env.rb")
end

desc "Echo to stdout an environment variable"
task :echo_env, [:var] => :config do |t, args|
  logger.info "#{args[:var]}: #{ENV[args[:var]]}"
end

desc "Run all tests"
Rake::TestTask.new(name=:spec) do |t|
  t.pattern = 'spec/*_spec.rb'
end

namespace :queue do
  require 'aws-sdk'

  desc "Create all queues"
  task :create do
    sqs = Aws::SQS::Client.new(region: ENV['AWS_REGION'])

    begin
      queue = sqs.create_queue({queue_name: 'RecentRequests'})
      logger.info "Queue created"
    rescue => e
      logger.info "Error creating queue: #{e}"
    end
  end
end

namespace :db do
  require_relative 'config/database'
  require_relative 'app/models/item'

  task :migrate do
    begin
      UserRequest.create_table
      logger.info 'UserRequest table created'
      Item.create_table
      logger.info 'Item table created'
      Store.create_table
      logger.info 'Store table created'
      User.create_table
      logger.info 'User table created'
    rescue Aws::DynamoDB::Errors::ResourceInUseException => e
      logger.info 'Error creating tables'
    end
  end
end

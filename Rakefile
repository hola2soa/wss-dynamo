require 'rake/testtask'
require 'config_env/rake_tasks'

require ::File.expand_path('../config/environments', __FILE__)

task :config do
  ConfigEnv.path_to_config("#{__dir__}/config/config_env.rb")
end

desc "Echo to stdout an environment variable"
task :echo_env, [:var] => :config do |t, args|
  puts "#{args[:var]}: #{ENV[args[:var]]}"
end

desc "Run all tests"
Rake::TestTask.new(name=:spec) do |t|
  t.pattern = 'spec/*_spec.rb'
end

namespace :db do
  require_relative 'config/database'
  require_relative 'app/models/item'

  task :migrate do
    begin
      UserRequest.create_table
      puts 'UserRequest table created'
      Item.create_table
      puts 'Item table created'
      Store.create_table
      puts 'Store table created'
      User.create_table
      puts 'User table created'
    rescue Aws::DynamoDB::Errors::ResourceInUseException => e
      puts 'Error creating tables'
    end
  end
end

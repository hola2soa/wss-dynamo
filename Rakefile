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

  # desc "Create tutorial table"
  task :migrate do
    begin
      Item.create_table
      puts 'Item table created'
    rescue Aws::DynamoDB::Errors::ResourceInUseException => e
      puts 'Item table already exists'
    end
  end
end

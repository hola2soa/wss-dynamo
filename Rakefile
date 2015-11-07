require 'rake/testtask'
require 'sinatra/activerecord/rake'
require 'rake/testtask'
require ::File.expand_path('../config/environments', __FILE__)

task :default => :spec

Rake::TestTask.new(name=:spec) do |t|
  t.pattern = 'spec/*_spec.rb'
end

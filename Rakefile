require 'rake/testtask'
require 'sinatra/activerecord/rake'
require 'rake/testtask'

task :default => :spec

Rake::TestTask.new(name=:spec) do |t|
  t.pattern = 'spec/*_spec.rb'
end

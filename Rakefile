require 'rake'
require 'rake/testtask'
require 'rake/clean'

task :default => :test

Rake::TestTask.new(:test) do |t|
  t.pattern = "test/**/*_test.rb"
  t.verbose = false
end

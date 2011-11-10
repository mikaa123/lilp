require 'bundler'

# This adds 'lib/' to the $LOAD_PATH
Bundler::GemHelper.install_tasks

task :default => :test

task :test do
  Dir["test/**_test.rb"].each{ |r| require_relative r }
end
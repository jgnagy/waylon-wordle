# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

require "rubocop/rake_task"

RuboCop::RakeTask.new

task default: %i[spec rubocop]

task :demo do
  require "waylon/core"
  require "waylon/wordle"
  Waylon::Logger.logger = ::Logger.new("/dev/null")
  Waylon::Cache.storage = Moneta.new(:Cookie)
  Waylon::Storage.storage = Moneta.new(:Cookie)
  require "waylon/rspec/test_server"
end

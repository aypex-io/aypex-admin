require "rubygems"
require "standard/rake"
require "rake"
require "rake/testtask"
require "rspec/core/rake_task"
require "aypex/backend/testing_support/aypex_admin_rake"

RSpec::Core::RakeTask.new

task default: :spec

desc "Generates a dummy app for testing"
task :test_app do
  ENV["LIB_NAME"] = "aypex/admin"
  Rake::Task["aypex_admin:test_app"].execute({install_admin: true, install_storefront: false})
end

source "https://rubygems.org"

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw]

%w[
  actionmailer actionpack actionview activejob activemodel activerecord
  activestorage activesupport railties
].each do |rails_gem|
  gem rails_gem, ENV.fetch("RAILS_VERSION", "~> 7.0.0"), require: false
end

platforms :jruby do
  gem "jruby-openssl"
end

platforms :ruby do
  if ENV["DB"] == "mysql"
    gem "mysql2"
  else
    gem "pg", "~> 1.1"
  end
end

group :test do
  gem "capybara"
  gem "capybara-screenshot"
  gem "database_cleaner"
  gem "debug"
  gem "email_spec"
  gem "factory_bot_rails"
  gem "jsonapi-rspec"
  gem "multi_json"
  gem "propshaft"
  gem "rails-controller-testing"
  gem "rspec-activemodel-mocks"
  gem "rspec_junit_formatter"
  gem "rspec-rails"
  gem "rspec-retry"
  gem "rswag-specs"
  gem "simplecov"
  gem "timecop"
  gem "webdrivers"
  gem "webmock"
end

group :test, :development do
  gem "appraisal"
  gem "awesome_print"
  gem "ffaker"
  gem "gem-release"
  gem "i18n-tasks"
  gem "puma"
  gem "redis"
  gem "rubocop"
  gem "rubocop-rspec", require: false
  gem "standard", "~> 1.20.0"
end

group :development do
  gem "solargraph"
  gem "erb_lint"
end

aypex_local_opts = {path: "../aypex"}
aypex_opts = {github: "aypex/aypex", branch: "main"}

gem "aypex_api", aypex_local_opts
gem "aypex_core", aypex_local_opts

gemspec

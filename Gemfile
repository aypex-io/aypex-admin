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

if ENV["DB"] == "mysql"
  gem "mysql2"
else
  gem "pg", "~> 1.1"
end

group :test, :development do
  gem "aypex_dev_tools", github: "aypex-io/aypex-dev-tools"
  gem "debug"
  gem "propshaft"
end

# Local dev
# aypex_opts = {path: "../aypex"}
aypex_opts = {github: "aypex-io/aypex", branch: "main"}

gem "aypex_api", aypex_opts
gem "aypex_core", aypex_opts

gemspec

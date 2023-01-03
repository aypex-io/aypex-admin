unless defined?(Aypex::InstallGenerator)
  require "generators/aypex/install/install_generator"
end

require "generators/aypex/dummy/dummy_generator"
require "generators/aypex/dummy_model/dummy_model_generator"

desc "Generates a dummy app for testing"
namespace :aypex_admin do
  task :test_app, :user_class do |_t, args|
    args.with_defaults(user_class: "Aypex::LegacyUser")
    require ENV["LIB_NAME"].to_s

    ENV["RAILS_ENV"] = "test"
    ENV["DUMMY_PATH"] = "tmp/dummy"

    Rails.env = "test"

    $stdout.puts "(1 of 4) Building dummy app for testing #{ENV["LIB_NAME"]}"
    Aypex::DummyGenerator.start ["--lib_name=#{ENV["LIB_NAME"]}", "--quiet"]
    Aypex::InstallGenerator.start [
      "--lib_name=#{ENV["LIB_NAME"]}",
      "--auto-accept",
      "--migrate=false",
      "--seed=false",
      "--sample=false",
      "--quiet",
      "--user_class=#{args[:user_class]}"
    ]

    $stdout.puts "(2 of 4) Setting up dummy database..."
    system("bin/rails db:environment:set RAILS_ENV=test")
    system("bundle exec rake db:drop db:create")
    Aypex::DummyModelGenerator.start
    system("bundle exec rake db:migrate")

    $stdout.puts "(3 of 4) Bundling ..."
    system("bundle install")

    $stdout.puts "(4 of 4) Precompiling assets..."
    system("bundle exec rake assets:precompile")

    $stdout.puts "Fin!"
  end
end

module Aypex
  module Admin
    module Generators
      class InstallGenerator < Rails::Generators::Base
        class_option :migrate, type: :boolean, default: true, banner: "Migrate the database"
        class_option :add_migrations, type: :boolean, default: true, banner: "Migrate the database"

        def add_migrations
          if options[:add_migrations] == true
            run "bundle exec rake railties:install:migrations FROM=aypex_admin"
          else
            puts "Skipping rake railties:install:migrations"
          end
        end

        def run_migrations
          if options[:migrate] == true
            run "bundle exec rake db:migrate VERBOSE=false"
          else
            puts "Skipping rake db:migrate, don't forget to run it!"
          end
        end
      end
    end
  end
end

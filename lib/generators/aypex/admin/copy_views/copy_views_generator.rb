module Aypex
  module Admin
    class CopyViewsGenerator < Rails::Generators::Base
      desc "Copies views from aypex admin to your application"

      def self.source_paths
        [File.expand_path("../../../../../app", __dir__)]
      end

      def copy_views
        directory "views", "./app/views"
      end
    end
  end
end

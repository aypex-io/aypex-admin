module Aypex
  module Admin
    class CopyCssGenerator < Rails::Generators::Base
      desc "Copies CSS from Aypex Admin to your applications vendor directory"

      def self.source_paths
        [File.expand_path("../../../../../", __dir__)]
      end

      def copy_css
        template "app/assets/stylesheets/aypex/admin/aypex_admin.css", "vendor/assets/stylesheets/aypex/admin/aypex_admin.css"
      end
    end
  end
end

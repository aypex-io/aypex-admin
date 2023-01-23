require "rails/engine"
require_relative "configuration"

module Aypex
  module Admin
    class Engine < Rails::Engine
      isolate_namespace Aypex
      engine_name "aypex_admin"

      initializer "aypex.admin.environment", before: :load_config_initializers do |_app|
        Aypex::Admin::Config = Aypex::Admin::Configuration.new
      end

      def self.activate
        Dir.glob(File.join(File.dirname(__FILE__), "../../../app/**/aypex/admin/*_decorator*.rb")).sort.each do |c|
          Rails.application.config.cache_classes ? require(c) : load(c)
        end
      end

      config.to_prepare(&method(:activate).to_proc)
    end
  end
end

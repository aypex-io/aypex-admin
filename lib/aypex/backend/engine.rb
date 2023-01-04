require "rails/engine"
require_relative "configuration"

module Aypex
  module Backend
    class Engine < Rails::Engine
      isolate_namespace Aypex
      engine_name "aypex_backend"

      initializer "aypex.backend.environment", before: :load_config_initializers do |_app|
        Aypex::Backend::Config = Aypex::Backend::Configuration.new
      end

      def self.activate
        Dir.glob(File.join(File.dirname(__FILE__), "../../../app/**/aypex/*_decorator*.rb")).sort.each do |c|
          Rails.application.config.cache_classes ? require(c) : load(c)
        end
      end

      def self.api_available?
        @@api_available ||= ::Rails::Engine.subclasses.map(&:instance).map { |e| e.class.to_s }.include?("Aypex::Api::Engine")
      end

      def self.checkout_available?
        @@checkout_available ||= ::Rails::Engine.subclasses.map(&:instance).map { |e| e.class.to_s }.include?("Aypex::Checkout::Engine")
      end

      def self.frontend_available?
        @@frontend_available ||= ::Rails::Engine.subclasses.map(&:instance).map { |e| e.class.to_s }.include?("Aypex::Frontend::Engine")
      end

      def self.emails_available?
        @@emails_available ||= ::Rails::Engine.subclasses.map(&:instance).map { |e| e.class.to_s }.include?("Aypex::Emails::Engine")
      end

      # filter sensitive information during logging
      initializer "aypex.params.filter" do |app|
        app.config.filter_parameters += [:password, :password_confirmation, :number]
      end

      config.to_prepare(&method(:activate).to_proc)
    end
  end
end

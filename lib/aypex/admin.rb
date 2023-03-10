require "aypex"
require "aypex/api"
require "aypex/admin/engine"
require "aypex/admin/action_callbacks"
require "aypex/admin/callbacks"
require "aypex/admin/configuration"

require "inline_svg"
require "pagy"
require "responders"
require "turbo-rails"

module Aypex
  module Admin
    # Used to configure Aypex Admin.
    #
    # Example:
    #   Aypex::Admin.configure do |config|
    #     config.admin_path = '/backend'
    #   end
    def self.configure
      yield(Aypex::Admin::Config)
    end
  end
end

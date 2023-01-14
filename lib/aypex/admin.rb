require "aypex"
require "aypex/api"
require "aypex/admin/engine"

require "turbo-rails"
require "inline_svg"
require "responders"
require "pagy"

require "aypex/admin/action_callbacks"
require "aypex/admin/callbacks"

module Aypex
  def self.admin_path
    Aypex::Admin::Config.admin_path
  end

  # Used to configure admin_path for Aypex
  #
  # Example:
  #
  # write the following line in `config/initializers/aypex.rb`
  #   Aypex.admin_path = '/custom-path'
  def self.admin_path=(path)
    Aypex::Admin::Config.admin_path = path
  end

  module Admin
  end
end

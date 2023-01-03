require "aypex/admin"

module Aypex
  def self.admin_path
   Aypex::Backend::Config.admin_path
  end

  # Used to configure admin_path for Aypex
  #
  # Example:
  #
  # write the following line in `config/initializers/aypex.rb`
  #   Aypex.admin_path = '/custom-path'
  def self.admin_path=(path)
    Aypex::Backend::Config.admin_path = path
  end
end



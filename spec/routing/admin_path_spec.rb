require "spec_helper"

module Aypex
  module Admin
    RSpec.describe "AdminPath", type: :routing do
      it "should route to admin by default" do
        expect(aypex.admin_path).to eq("/admin")
      end

      it "routes to the the configured path" do
        Aypex::Admin::Config.admin_path = "/secret"
        Rails.application.reload_routes!
        expect(aypex.admin_path).to eq("/secret")

        # restore the path for other tests
        Aypex::Admin::Config.admin_path = "/admin"
        Rails.application.reload_routes!
        expect(aypex.admin_path).to eq("/admin")
      end
    end
  end
end

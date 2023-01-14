require "spec_helper"

RSpec.describe Aypex::Admin::Configuration do
  subject(:test_subject) { Aypex::Admin::Config }

  before { described_class.new }

  describe "#admin_path" do
    after { test_subject.admin_path = "/admin" }

    it "defaults to '/admin' / accessible through Aypex::Config" do
      expect(test_subject.admin_path).to eq "/admin"
    end

    it "is settable directly" do
      test_subject.admin_path = "/backend"
      expect(test_subject.admin_path).to eq "/backend"
    end

    it "is settable via block" do
      Aypex::Admin.configure do |config|
        config.admin_path = "/admin-ui"
      end
      expect(test_subject.admin_path).to eq "/admin-ui"
    end

    it "returns error if not an String" do
      test_subject.admin_path = true
      expect { raise "Aypex::Config.storefront_products_path MUST be an String" }.to raise_error(RuntimeError)
    end
  end
end

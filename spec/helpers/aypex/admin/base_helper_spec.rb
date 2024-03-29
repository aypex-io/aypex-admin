require "spec_helper"

describe Aypex::Admin::BaseHelper, type: :helper do
  include Aypex::Admin::BaseHelper

  context "#datepicker_field_value" do
    it "returns nil when date is empty" do
      date = nil
      expect(datepicker_field_value(date)).to be_nil
    end

    it "returns a formatted date when date is present" do
      date = "2013-08-14".to_time
      expect(datepicker_field_value(date)).to eq("2013/08/14")
    end
  end

  context "#plural_resource_name" do
    it "returns correct form of class" do
      resource_class = Aypex::Product
      expect(plural_resource_name(resource_class)).to eq("Products")
    end
  end

  context "#order_time" do
    it "prints in a format" do
      time = Time.new(2016, 5, 6, 13, 33)
      expect(order_time(time)).to eq "2016-05-06 1:33 PM #{time.zone}"
    end

    it "return empty string when nil is supplied" do
      expect(order_time(nil)).to eq ""
    end
  end

  describe "#admin_logout_route" do
    it "returns nil if no logout route is defined" do
      expect(helper.admin_logout_route).to be_nil
    end

    context "returns aypex_logout_path if defined" do
      before { allow(helper).to receive(:aypex_logout_path).and_return("/logout") }

      it { expect(helper.admin_logout_route).to eq("/logout") }
    end

    context "aypex.admin_logout_path if defined" do
      before do
        allow(helper).to receive(:aypex_logout_path).and_return("/logout")
        allow(helper).to receive(:admin_logout_path).and_return("/admin/logout")
      end

      it { expect(helper.admin_logout_route).to eq("/admin/logout") }
    end
  end

  describe "#admin_unauthorized_route" do
    context "when no paths are present" do
      it "returns'/'" do
        expect(helper.admin_unauthorized_route).to eq("/")
      end
    end

    context "when :admin_forbidden_path is present" do
      before { allow(helper).to receive(:admin_forbidden_path).and_return("/admin/forbidden") }

      it "returns '/admin/forbidden'" do
        expect(helper.admin_unauthorized_route).to eq("/admin/forbidden")
      end
    end

    context "when only aypex_unauthorized_path is defined" do
      before { allow(helper).to receive(:aypex_unauthorized_path).and_return("/unauthorized") }

      it "returns '/admin/forbidden'" do
        expect(helper.admin_unauthorized_route).to eq("/unauthorized")
      end
    end
  end
end

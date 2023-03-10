require "spec_helper"

describe Aypex::Admin::ProductsHelper, type: :helper do
  context "#available_status" do
    subject(:status) { helper.available_status(product) }

    let(:store) { Aypex::Store.default }
    let(:product) { create(:product, stores: [store]) }

    context "product is available" do
      it "has available status" do
        expect(status).to eq(I18n.t("aypex.admin.active"))
      end
    end

    context "product was deleted" do
      before do
        product.delete
      end

      it "has deleted status" do
        expect(status).to eq(I18n.t("aypex.admin.deleted"))
      end
    end

    context "product is discontinued" do
      before do
        product.discontinue!
      end

      it "has discontinued status" do
        expect(status).to eq(I18n.t("aypex.admin.archived"))
      end
    end

    context "draft product" do
      before do
        product.status = "draft"
      end

      it "has draft status" do
        expect(status).to eq(I18n.t("aypex.admin.draft"))
      end
    end
  end
end

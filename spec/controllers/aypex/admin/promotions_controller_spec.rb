require "spec_helper"

describe Aypex::Admin::PromotionsController, type: :controller do
  stub_authorization!

  let(:store) { Aypex::Store.default }
  let(:store_2) { create(:store) }

  let!(:promotion1) { create(:promotion, name: "name1", code: "code1", path: "path1", stores: [store, store_2]) }
  let!(:promotion2) { create(:promotion, name: "name2", code: "code2", path: "path2", stores: [store]) }
  let!(:promotion3) { create(:promotion, name: "name3", code: "code3", path: "path3", stores: [store_2]) }
  let!(:category) { create :promotion_category }

  describe "#index" do
    it "succeeds" do
      get :index
      expect(assigns[:promotions]).to match_array [promotion2, promotion1]
    end

    it "assigns promotion categories" do
      get :index
      expect(assigns[:promotion_categories]).to match_array [category]
    end

    context "search" do
      it "pages results" do
        get :index, params: {per_page: "1"}
        expect(assigns[:promotions]).to eq [promotion2]
      end

      it "filters by name" do
        get :index, params: {q: {name_cont: promotion1.name}}
        expect(assigns[:promotions]).to eq [promotion1]
      end

      it "filters by code" do
        get :index, params: {q: {code_cont: promotion1.code}}
        expect(assigns[:promotions]).to eq [promotion1]
      end

      it "filters by path" do
        get :index, params: {q: {path_cont: promotion1.path}}
        expect(assigns[:promotions]).to eq [promotion1]
      end
    end
  end

  describe "#clone" do
    subject do
      post :clone, params: {id: promotion1.id}
    end

    it "creates a copy of promotion" do
      expect { subject }.to change { Aypex::Promotion.count }.by(1)
    end

    it "creates a copy of promotion with changed fields" do
      subject
      new_promo = Aypex::Promotion.last
      expect(new_promo.name).to eq "New name1"
      expect(new_promo.code).to match(/code1_[a-zA-Z]{4}/)
      expect(new_promo.path).to match(/path1_[a-zA-Z]{4}/)
    end
  end

  describe "#destroy" do
    subject(:send_request) do
      delete :destroy, params: {id: promotion, format: :turbo_stream}
    end

    context "will successfully destroy promotion" do
      let!(:promotion) { create(:promotion, stores: [store, store_2]) }

      describe "returns response" do
        before { send_request }

        it { expect(assigns(:promotion)).to eq(promotion) }
        it { expect(response).to have_http_status(:ok) }

        it { expect(flash[:message]).to be_nil }
      end
    end

    context "cannot destroy promotion from different store" do
      let!(:promotion) { create(:promotion, stores: [store_2]) }

      it { expect(send_request).to redirect_to(aypex.admin_promotions_path) }
      it { expect { send_request }.not_to change { Aypex::Promotion.count } }
    end
  end
end

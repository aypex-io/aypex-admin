require "spec_helper"

describe Aypex::Admin::BaseCategoriesController, type: :controller do
  stub_authorization!

  let(:store) { create(:store) }
  let(:new_store) { create(:store) }
  let!(:base_category_1) { create(:base_category, store: store) }
  let!(:base_category_2) { create(:base_category, store: store) }
  let!(:base_category_3) { create(:base_category) }

  before do
    allow_any_instance_of(described_class).to receive(:current_store).and_return(store)
  end

  describe "#index" do
    it "should assign only the store credits for user and current store" do
      get :index
      expect(assigns(:collection)).to include base_category_1
      expect(assigns(:collection)).to include base_category_2
      expect(assigns(:collection)).not_to include base_category_3
    end
  end

  context "#new" do
    it "should create base_category" do
      get :new
      expect(response.status).to eq(200)
    end
  end

  describe "#create" do
    let(:request) { post :create, params: {base_category: {name: "Shirts"}} }

    it "should create base_category for current store" do
      expect { request }.to change { store.base_categories.count }.by(1)
      expect(response).to be_redirect
    end

    context "different store" do
      subject(:create_request) { post(:create, params: {base_category: {name: "Bags"}}) }

      before do
        allow_any_instance_of(described_class).to receive(:current_store).and_return(new_store)
      end

      it "should not create base_category for store" do
        expect { subject }.not_to change { store.base_categories.reload.count }
        expect(response).to be_redirect
      end

      it "should create base_category for new store" do
        expect { subject }.to change { new_store.base_categories.reload.count }.by(1)
        expect(response).to be_redirect
      end
    end
  end

  describe "#update" do
    it "should allow to update current store base_category" do
      expect { put(:update, params: {id: base_category_1.id, base_category: {name: "Beverages"}}) }.to change { base_category_1.reload.name }.to("Beverages")
    end

    it "should not allow to update not current store base_category" do
      expect { put(:update, params: {id: base_category_3.id, base_category: {name: "Shoes"}}) }.not_to change { base_category_3.reload.name }
    end
  end

  describe "#destroy" do
    before { delete :destroy, params: {id: base_category.id} }

    context "when current store base_category" do
      let(:base_category) { base_category_1 }

      it "should be able to destroy base_category" do
        expect(assigns(:object)).to eq(base_category)
        expect(response).to have_http_status(:found)

        expect(flash[:kind]).to eq(:success)
        expect(flash[:message]).to eq("Base Category \"#{base_category.name}\" has been successfully removed!")
      end
    end

    context "when not current store base_category" do
      let(:base_category) { base_category_3 }

      it "should be able to destroy base_category" do
        expect(assigns(:object)).to be_nil

        expect(flash[:kind]).to eq(:error)
        expect(flash[:message]).to eq("Base Category is not found")
      end
    end
  end
end

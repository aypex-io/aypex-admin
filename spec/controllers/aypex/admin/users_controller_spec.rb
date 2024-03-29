require "spec_helper"
require "testing_support/bar_ability"

describe Aypex::Admin::UsersController, type: :controller do
  let(:store) { Aypex::Store.default }
  let(:user) { create(:user) }
  let(:mock_user) { stub_model Aypex::Config.user_class }

  before do
    allow(controller).to receive_messages aypex_current_user: user
    user.aypex_roles.clear
    stub_const("Aypex::User", user.class)
  end

  context "#show" do
    before do
      user.aypex_roles << Aypex::Role.find_or_create_by(name: "admin")
    end

    it "redirects to edit" do
      get :show, params: {id: user.id}
      expect(response).to redirect_to aypex.edit_admin_user_path(user)
    end
  end

  context "#authorize_admin" do
    before { use_mock_user }

    it "grant access to users with an admin role" do
      user.aypex_roles << Aypex::Role.find_or_create_by(name: "admin")
      post :index
      expect(response).to render_template :index
    end

    it "deny access to users without an admin role" do
      allow(user).to receive_messages has_aypex_role?: false
      post :index
      expect(response).to redirect_to(aypex.admin_forbidden_path)
    end

    describe "deny access to users with an bar role" do
      before do
        user.aypex_roles << Aypex::Role.find_or_create_by(name: "bar")
        Aypex::Ability.register_ability(BarAbility)
      end

      after do
        Aypex::Ability.remove_ability(BarAbility)
      end

      it "#index" do
        post :index
        expect(response).to redirect_to(aypex.admin_forbidden_path)
      end

      it "#update" do
        post :update, params: {id: "9"}
        expect(response).to redirect_to(aypex.admin_forbidden_path)
      end
    end
  end

  describe "#create" do
    before do
      use_mock_user
      user.aypex_roles << Aypex::Role.find_or_create_by(name: "admin")
    end

    let(:permitted_user_attrs) do
      (permitted_user_attributes.reject { |attr| attr.is_a? Hash } +
        permitted_user_attributes.select { |attr| attr.is_a? Hash }.map(&:keys)).flatten
    end

    it "can create a shipping_address" do
      expect(Aypex::Config.user_class).to receive(:new).with(ActionController::Parameters.new(
        "ship_address_attributes" => {"city" => "New York"}
      ).permit(ship_address_attributes: permitted_address_attributes))
      post :create, params: {user: {ship_address_attributes: {city: "New York"}}}
    end

    it "can create a billing_address" do
      expect(Aypex::Config.user_class).to receive(:new).with(ActionController::Parameters.new(
        "bill_address_attributes" => {"city" => "New York"}
      ).permit(bill_address_attributes: permitted_address_attributes))
      post :create, params: {user: {bill_address_attributes: {city: "New York"}}}
    end

    it "redirects to user edit page" do
      post :create, params: {user: user.slice(permitted_user_attrs)}
      expect(response).to redirect_to(aypex.edit_admin_user_path(assigns[:user]))
    end
  end

  describe "#update" do
    before do
      use_mock_user
      user.aypex_roles << Aypex::Role.find_or_create_by(name: "admin")
    end

    it "allows shipping address attributes through" do
      expect(mock_user).to receive(:update).with(ActionController::Parameters.new(
        "ship_address_attributes" => {"city" => "New York"}
      ).permit(ship_address_attributes: permitted_address_attributes))
      put :update, params: {id: mock_user.id, user: {ship_address_attributes: {city: "New York"}}}
    end

    it "allows billing address attributes through" do
      expect(mock_user).to receive(:update).with(ActionController::Parameters.new(
        "bill_address_attributes" => {"city" => "New York"}
      ).permit(bill_address_attributes: permitted_address_attributes))
      put :update, params: {id: mock_user.id, user: {bill_address_attributes: {city: "New York"}}}
    end

    it "allows updating without password resetting" do
      expect(mock_user).to receive(:update).with(hash_not_including(password: "", password_confirmation: ""))
      put :update, params: {id: mock_user.id, user: {password: "", password_confirmation: "", email: "aypex@example.com"}}
    end

    xit "redirects to user edit page" do
      expect(mock_user).to receive(:update).with(hash_not_including(email: "")).and_return(true)
      put :update, params: {id: mock_user.id, user: {email: "aypex@example.com"}}
      expect(response).to redirect_to(aypex.edit_admin_user_path(mock_user))
    end

    it "render edit page when update got errors" do
      expect(mock_user).to receive(:update).with(hash_not_including(email: "")).and_return(false)
      put :update, params: {id: mock_user.id, user: {email: "invalid_email"}}
      expect(response).to render_template(:edit)
    end
  end

  describe "#orders" do
    let!(:order) { create(:order, user: user, store: store) }
    let!(:order_2) { create(:order, user: user, store: create(:store)) }
    let!(:order_3) { create(:completed_order_with_totals, user: user, store: store) }

    before do
      user.aypex_roles << Aypex::Role.find_or_create_by(name: "admin")
    end

    it "assigns a list of the users completed orders" do
      get :orders, params: {id: user.id}
      expect(assigns[:orders].count).to eq 1
      expect(assigns[:orders].first).to eq order_3
    end

    it "assigns a ransack search for Aypex::Order" do
      get :orders, params: {id: user.id}
      expect(assigns[:search]).to be_a Ransack::Search
      expect(assigns[:search].klass).to eq Aypex::Order
    end
  end
end

def use_mock_user
  allow(mock_user).to receive(:save).and_return(true)
  allow(Aypex::Config.user_class).to receive(:find).with(mock_user.id.to_s).and_return(mock_user)
  allow(Aypex::Config.user_class).to receive(:new).and_return(mock_user)
end

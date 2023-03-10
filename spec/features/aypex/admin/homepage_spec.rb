require "spec_helper"

describe "Homepage", type: :feature do
  context "as admin user" do
    stub_authorization!

    context "test JavaScript", js: true do
      before do
        visit aypex.admin_path
      end

      it "not show products link" do
        expect(page).not_to have_link("Products", href: "/admin/products")
      end
    end

    context "visiting the homepage" do
      before do
        visit aypex.admin_path
      end

      it "has a link to products" do
        expect(page).to have_link("Products", href: "/admin/products")
      end

      it "has a link to stock" do
        expect(page).to have_link("Stock", href: "#sidebar-stock")
      end

      it "has a link to reports" do
        expect(page).to have_link("Reports", href: "/admin/reports")
      end

      it "has a link to return authorizations" do
        within(".sidebar") { expect(page).to have_link("Return Authorizations", href: "/admin/return_authorizations") }
      end

      it "has a link to customer returns" do
        within(".sidebar") { expect(page).to have_link("Customer Returns", href: "/admin/customer_returns") }
      end
    end

    context "visiting the orders tab" do
      before do
        visit aypex.admin_orders_path(q: {completed_at_not_null: "1"})
      end

      it "has a link to all orders" do
        within(".sidebar") { expect(page).to have_link("All Orders", href: "/admin/orders") }
      end

      it "has a link to draft orders" do
        within(".sidebar") { expect(page).to have_link("Draft Orders", href: "/admin/orders?q%5Bcompleted_at_not_null%5D=false&q%5Bstate_eq%5D=cart") }
      end

      it "has a link to abandoned checkouts" do
        within(".sidebar") { expect(page).to have_link("Abandoned Checkouts", href: "/admin/orders?q%5Bcompleted_at_not_null%5D=false&q%5Bstate_in%5D%5B%5D=address&q%5Bstate_in%5D%5B%5D=delivery&q%5Bstate_in%5D%5B%5D=payment&q%5Bstate_in%5D%5B%5D=confirm") }
      end
    end

    context "visiting the products tab" do
      before do
        visit aypex.admin_products_path
      end

      it "has a link to products" do
        within(".sidebar") { expect(page).to have_link("Products", href: "/admin/products") }
      end

      it "has a link to option types" do
        within(".sidebar") { expect(page).to have_link("Option Types", href: "/admin/option_types") }
      end

      it "has a link to properties" do
        within(".sidebar") { expect(page).to have_link("Properties", href: "/admin/properties") }
      end

      it "has a link to prototypes" do
        within(".sidebar") { expect(page).to have_link("Prototypes", href: "/admin/prototypes") }
      end
    end

    context "visiting the stock tab" do
      before do
        visit aypex.admin_stock_transfers_path
      end

      it "has a link to stock transfers" do
        within(".sidebar") { expect(page).to have_link("Stock Transfers", href: "/admin/stock_transfers") }
      end

      it "has a link to stock locations" do
        within(".sidebar") { expect(page).to have_link("Stock Locations", href: "/admin/stock_locations") }
      end
    end
  end

  context "as fakedispatch user" do
    let(:admin_app) { Aypex::OauthApplication.create(name: "Admin Panel", scopes: "admin") }
    let(:admin_token) { Aypex::OauthAccessToken.create!(application: admin_app, scopes: "admin").token }

    before do
      allow_any_instance_of(Aypex::Admin::BaseController).to receive(:aypex_current_user).and_return(Aypex::Config.user_class.new)
      allow_any_instance_of(Aypex::Admin::BaseController).to receive(:admin_oauth_application).and_return(admin_app)
      allow_any_instance_of(Aypex::Admin::BaseController).to receive(:admin_oauth_token).and_return(admin_token)
    end

    custom_authorization! do |_user|
      can [:admin, :edit, :index, :read], Aypex::Order
    end

    it "only displays tabs fakedispatch has access to" do
      visit aypex.admin_path
      expect(page).to have_link("Orders")
      expect(page).not_to have_link("Products")
      expect(page).not_to have_link("Promotions")
      expect(page).not_to have_link("Reports")
      expect(page).not_to have_link("Settings")
    end
  end
end

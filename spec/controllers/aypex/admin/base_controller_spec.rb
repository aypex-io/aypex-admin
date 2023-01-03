# Aypex's rpsec controller tests get the Aypex::ControllerHacks
# we don't need those for the anonymous controller here, so
# we call process directly instead of get
require "spec_helper"

class AdminFakesController < Aypex::Admin::BaseController
  def index
    render plain: "index"
  end
end

describe Aypex::Admin::BaseController, type: :controller do
  controller(Aypex::Admin::BaseController) do
    def index
      authorize! :update, Aypex::Order
      render plain: "test"
    end
  end

  describe "#redirect_unauthorized_access" do
    controller(AdminFakesController) do
      def index
        redirect_unauthorized_access
      end
    end

    context "when logged in" do
      before do
        allow(controller).to receive_messages(try_aypex_current_user: double("User", id: 1, last_incomplete_aypex_order: nil, persisted?: true))
      end

      it "redirects forbidden path" do
        get :index
        expect(response).to redirect_to("/admin/forbidden")
      end
    end

    context "when guest user" do
      before do
        allow(controller).to receive_messages(try_aypex_current_user: nil)
      end

      it "redirects login path" do
        allow(controller).to receive_messages(aypex_login_path: "/login")
        get :index
        expect(response).to redirect_to("/login")
      end

      context "redirects to root" do
        it "of aypex" do
          allow(controller).to receive_message_chain(:aypex, :root_path).and_return("/root")
          get :index
          expect(response).to redirect_to "/root"
        end

        it "of main app" do
          get :index
          expect(response).to redirect_to "/"
        end
      end
    end
  end
end

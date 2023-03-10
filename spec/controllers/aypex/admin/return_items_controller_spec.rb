require "spec_helper"

describe Aypex::Admin::ReturnItemsController, type: :controller do
  stub_authorization!

  describe "#update" do
    subject do
      put :update, params: {id: return_item.to_param, return_item: {acceptance_status: new_acceptance_status}}
    end

    let(:customer_return) { create(:customer_return) }
    let(:return_item) { customer_return.return_items.first }
    let(:old_acceptance_status) { "accepted" }
    let(:new_acceptance_status) { "rejected" }

    it "updates the return item" do
      expect do
        subject
      end.to change { return_item.reload.acceptance_status }.from(old_acceptance_status).to(new_acceptance_status)
    end

    it "redirects to the customer return" do
      subject
      expect(response).to redirect_to aypex.edit_admin_order_customer_return_path(customer_return.order, customer_return)
    end
  end
end

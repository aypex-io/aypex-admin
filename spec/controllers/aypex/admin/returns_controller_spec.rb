require "spec_helper"

module Aypex
  module Admin
    describe ReturnsController, type: :controller do
      stub_authorization!

      describe "#return_authorizations" do
        subject do
          get :return_authorizations
        end

        let(:return_authorization) { create(:return_authorization) }
        let(:order_other_store) { create(:shipped_order, store: create(:store)) }
        let(:return_authorization_other_store) { create(:return_authorization, order: order_other_store) }

        before { subject }

        it "loads return authorizations" do
          expect(assigns(:collection)).to include(return_authorization)
        end

        it "does not include other store return authorization" do
          expect(assigns(:collection)).not_to include(return_authorization_other_store)
        end
      end

      describe "#customer_returns" do
        subject do
          get :customer_returns
        end

        let(:customer_return) { create(:customer_return) }

        it "loads customer returns" do
          subject
          expect(assigns(:collection)).to include(customer_return)
        end

        context "when current store is different than customer return order store" do
          let(:new_store) { create(:store) }

          before { allow_any_instance_of(described_class).to receive(:current_store).and_return(new_store) }

          it "should not load customer returns" do
            subject
            expect(assigns(:collection)).to be_empty
          end
        end
      end
    end
  end
end

require "spec_helper"

module Aypex
  module Admin
    describe AdjustmentsController, type: :controller do
      stub_authorization!

      describe "#index" do
        subject do
          get :index, params: {order_id: order.to_param}
        end

        let!(:order) { create(:order) }
        let!(:adjustment_1) { create(:adjustment, order: order) }

        before do
          create(:adjustment, order: order, eligible: false) # adjustment_2
          subject
        end

        it "returns 200 status" do
          expect(response.status).to eq 200
        end

        it "loads the order" do
          expect(assigns(:order)).to eq order
        end

        it "returns only eligible adjustments" do
          expect(assigns(:adjustments)).to match_array([adjustment_1])
        end
      end

      describe "#destroy" do
        subject(:destroy) do
          delete :destroy, params: {order_id: order.to_param, id: adjustment.id, format: :turbo_stream}
        end

        shared_examples "adjustment destroyed" do
          it "destroys one adjustment" do
            expect { destroy }.to change { Aypex::Adjustment.count }.by(-1)
          end

          it "assigns adjustment object to instance variable" do
            destroy

            expect(assigns(:adjustment)).to eq(adjustment)
          end

          it "returns 200 status" do
            destroy

            expect(response).to have_http_status(:ok)
          end

          it "returns success flash response" do
            destroy

            expect(flash[:message]).to be_nil
          end

          it "leaves error flash empty" do
            destroy

            expect(flash[:message]).to be_nil
          end
        end

        context "when adjustment is created directly" do
          context "when is destroyed" do
            let!(:order) { create(:order) }
            let!(:adjustment) { create(:adjustment, order: order, source_type: nil, source: nil) }

            it_behaves_like "adjustment destroyed"
          end
        end
      end
    end
  end
end

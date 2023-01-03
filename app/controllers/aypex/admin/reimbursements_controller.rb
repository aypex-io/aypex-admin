module Aypex
  module Admin
    class ReimbursementsController < ResourceController
      belongs_to "aypex/order", find_by: :number

      before_action :load_simulated_refunds, only: :edit

      rescue_from Aypex::Core::GatewayError, with: :aypex_core_gateway_error

      def perform
        @reimbursement.perform!
        redirect_to location_after_save
      end

      private

      def build_resource
        if params[:build_from_customer_return_id].present?
          customer_return = CustomerReturn.find(params[:build_from_customer_return_id])

          Reimbursement.build_from_customer_return(customer_return)
        else
          super
        end
      end

      def location_after_save
        if @reimbursement.reimbursed?
          aypex.admin_order_reimbursement_path(parent, @reimbursement)
        else
          aypex.edit_admin_order_reimbursement_path(parent, @reimbursement)
        end
      end

      def load_simulated_refunds
        @reimbursement_objects = @reimbursement.simulate
      end

      def aypex_core_gateway_error(error)
        dispatch_notice(error.message, :error)
        redirect_to aypex.edit_admin_order_reimbursement_path(parent, @reimbursement)
      end
    end
  end
end

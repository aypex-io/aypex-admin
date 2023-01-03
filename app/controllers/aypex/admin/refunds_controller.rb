module Aypex
  module Admin
    class RefundsController < ResourceController
      belongs_to "aypex/payment", find_by: :number
      before_action :load_order

      helper_method :refund_reasons

      rescue_from Aypex::Core::GatewayError, with: :aypex_core_gateway_error

      private

      def location_after_save
        admin_order_payments_path(@payment.order)
      end

      def load_order
        # the aypex/admin/shared/order_tabs partial expects the @order instance variable to be set
        @order = @payment.order if @payment
      end

      def refund_reasons
        @refund_reasons ||= RefundReason.active.all
      end

      def build_resource
        super.tap do |refund|
          refund.amount = refund.payment.credit_allowed
        end
      end

      def aypex_core_gateway_error(error)
        dispatch_notice(error.message, :error)
        render :new
      end
    end
  end
end

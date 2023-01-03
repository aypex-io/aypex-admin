module Aypex
  module Admin
    class LogEntriesController < Aypex::Admin::BaseController
      include Aypex::Admin::OrderConcern
      before_action :load_order
      before_action :load_payment

      def index
        @log_entries = @payment.log_entries
      end

      private

      def load_payment
        @payment = @order.payments.find_by!(number: params[:payment_id])
      end
    end
  end
end

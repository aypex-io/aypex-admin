module Aypex
  module Admin
    class StateChangesController < Aypex::Admin::BaseController
      include Aypex::Admin::OrderConcern

      before_action :load_order, only: [:index]

      def index
        @state_changes = @order.state_changes.includes(:user).order(created_at: :desc)
      end
    end
  end
end

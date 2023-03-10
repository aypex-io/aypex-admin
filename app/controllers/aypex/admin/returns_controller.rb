module Aypex
  module Admin
    class ReturnsController < BaseController
      def return_authorizations
        collection(Aypex::ReturnAuthorization.for_store(current_store).accessible_by(current_ability, :index))
        respond_with(@collection)
      end

      def customer_returns
        collection(current_store.customer_returns.accessible_by(current_ability, :index))
        respond_with(@collection)
      end

      private

      def collection(resource)
        return @collection if @collection.present?

        params[:q] ||= {}

        # @search needs to be defined as this is passed to search_form_for
        @search = resource.ransack(params[:q])
        per_page = params[:per_page] || current_store.admin_customer_returns_per_page
        @collection = @search.result.order(created_at: :desc).page(params[:page]).per(per_page)
      end

      # this is needed for proper permissions checking
      def model_class
        (action == :customer_returns) ? Aypex::CustomerReturn : Aypex::ReturnAuthorization
      end
    end
  end
end

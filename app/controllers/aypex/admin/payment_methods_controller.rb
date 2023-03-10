module Aypex
  module Admin
    class PaymentMethodsController < ResourceController
      before_action :load_data
      before_action :validate_payment_method_provider, only: :create

      def create
        @payment_method = params[:payment_method].delete(:type).constantize.new(payment_method_params)
        @object = @payment_method
        set_current_store

        super
      end

      def update
        invoke_callbacks(:update, :before)
        payment_method_type = params[:payment_method].delete(:type)
        if @payment_method["type"].to_s != payment_method_type
          @payment_method.update_columns(
            type: payment_method_type,
            updated_at: Time.current
          )
          @payment_method = scope.find(params[:id])
        end

        attributes = payment_method_params.merge(preferences_params)
        attributes.each do |k, _v|
          attributes.delete(k) if k.include?("password") && attributes[k].blank?
        end

        if @payment_method.update(attributes)
          set_current_store
          invoke_callbacks(:update, :after)
          dispatch_notice(I18n.t("aypex.admin.successfully_updated", resource: I18n.t("aypex.admin.payment_method")), :success)

          redirect_to aypex.edit_admin_payment_method_path(@payment_method)
        else
          invoke_callbacks(:update, :fails)
          respond_with(@payment_method, status: :unprocessable_entity)
        end
      end

      private

      def load_main_menu_panel
        @menu_panel_kind = "settings"
      end

      def scope
        current_store.payment_methods.accessible_by(current_ability, :index)
      end

      def collection
        return @collection if @collection.present?

        params[:q] ||= {}
        @collection = super.order(position: :asc)

        @collection = scope.order(position: :asc)

        @search = @collection.ransack(params[:q])
        @collection = @search.result.page(params[:page]).per(params[:per_page])
      end

      def load_data
        @providers = Gateway.providers.sort_by(&:name)
      end

      def validate_payment_method_provider
        valid_payment_methods = Rails.application.config.aypex.payment_methods.map(&:to_s)
        unless valid_payment_methods.include?(params[:payment_method][:type])
          dispatch_notice(I18n.t("aypex.admin.invalid_payment_provider"), :error)
          redirect_to aypex.new_admin_payment_method_path
        end
      end

      def payment_method_params
        params.require(:payment_method).permit!
      end

      def preferences_params
        key = ActiveModel::Naming.param_key(@payment_method)
        return {} unless params.key? key

        params.require(key).permit!
      end

      def location_after_save
        aypex.edit_admin_payment_method_path(@payment_method)
      end
    end
  end
end

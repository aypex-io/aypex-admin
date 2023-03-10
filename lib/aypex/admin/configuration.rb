module Aypex
  module Admin
    class Configuration
      attr_writer :admin_path

      def admin_path
        self.admin_path = "/admin" unless @admin_path

        if @admin_path.is_a?(String)
          @admin_path
        else
          raise "Aypex::Admin::Config.admin_path MUST be an String"
        end
      end

      ORDER_TABS = [:orders, :payments, :creditcard_payments,
        :shipments, :credit_cards, :return_authorizations,
        :customer_returns, :adjustments, :customer_details]
      PRODUCT_TABS = [:products, :option_types, :properties, :prototypes,
        :variants, :product_properties, :base_categories,
        :categories]
      REPORT_TABS = [:reports]
      CONFIGURATION_TABS = [:configurations, :general_settings, :tax_categories,
        :tax_rates, :zones, :countries, :states,
        :payment_methods, :shipping_methods,
        :shipping_categories, :stock_transfers,
        :stock_locations, :trackers, :refund_reasons,
        :reimbursement_types, :return_authorization_reasons,
        :stores]
      PROMOTION_TABS = [:promotions, :promotion_categories]
      USER_TABS = [:users]
    end
  end
end

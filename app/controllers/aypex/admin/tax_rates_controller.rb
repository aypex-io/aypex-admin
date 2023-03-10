module Aypex
  module Admin
    class TaxRatesController < ResourceController
      before_action :load_data

      private

      def load_main_menu_panel
        @menu_panel_kind = "settings"
      end

      def load_data
        @available_zones = Zone.order(:name)
        @available_categories = TaxCategory.order(:name)
        @calculators = TaxRate.calculators.sort_by(&:name)
      end
    end
  end
end

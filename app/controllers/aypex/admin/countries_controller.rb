module Aypex
  module Admin
    class CountriesController < ResourceController
      private

      def collection
        return @collection if @collection.present?

        per_page_limit = params[:per_page] || 50

        params[:q] ||= {}
        params[:q][:s] ||= "name asc"

        @collection = Aypex::Country.all.order(:name)
        @search = @collection.ransack(params[:q])
        @collection = @search.result
        @pagy, @collection = pagy(@collection, items: per_page_limit)

        @collection
      end

      def load_main_menu_panel
        @menu_panel_kind = "settings"
      end

      def location_after_save
        aypex.edit_admin_country_path(@object)
      end
    end
  end
end

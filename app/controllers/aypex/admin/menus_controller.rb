module Aypex
  module Admin
    class MenusController < ResourceController
      helper "aypex/admin/sortable_tree"

      def index
      end

      private

      def scope
        current_store.menus
      end

      def find_resource
        scope.find(params[:id])
      end

      def collection
        return @collection if @collection.present?

        params[:q] ||= {}
        @collection = scope

        @search = @collection.ransack(params[:q])
        @collection = @search.result.page(params[:page])
          .per(params[:per_page] || current_store.admin_menus_per_page)
      end

      def location_after_save
        aypex.edit_admin_menu_path(@menu)
      end
    end
  end
end

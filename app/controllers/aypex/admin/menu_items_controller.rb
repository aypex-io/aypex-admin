module Aypex
  module Admin
    class MenuItemsController < ResourceController
      belongs_to "aypex/menu"

      before_action :load_data

      def collection_url
        aypex.edit_admin_menu_path(@menu)
      end

      def location_after_save
        aypex.edit_admin_menu_menu_item_path(@menu, @menu_item)
      end

      def remove_icon
        if @menu_item.icon&.destroy
          dispatch_notice(I18n.t("aypex.admin.notice_messages.icon_removed"), :success)
          redirect_to aypex.edit_admin_menu_menu_item_path(@menu, @menu_item)
        else
          dispatch_notice(I18n.t("aypex.admin.errors.messages.cannot_remove_icon"), :error)
          render :edit
        end
      end

      private

      def load_data
        @menu_item_types = Aypex::MenuItem::ITEM_TYPE
      end

      def scope
        current_store.menu_items
      end
    end
  end
end

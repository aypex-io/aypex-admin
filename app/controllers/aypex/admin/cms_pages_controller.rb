module Aypex
  module Admin
    class CmsPagesController < ResourceController
      layout :resolve_layout

      def update_visibility
        if @object.update(visible: permitted_resource_params[:visible])
          respond_to do |format|
            format.turbo_stream
          end
        else
          stream_flash_alert(message: I18n.t("aypex.admin.could_not_update_page_visibility"), kind: :error)
        end
      end

      private

      def resolve_layout
        return "aypex/layouts/admin" if action_name == "index"

        case @object.type
        when "Aypex::Cms::Page::Homepage"
          "aypex/layouts/admin_editor_mode"
        when "Aypex::Cms::Page::FeaturePage"
          "aypex/layouts/admin_editor_mode"
        else
          "aypex/layouts/admin"
        end
      end

      def scope
        current_store.cms_pages
      end

      def find_resource
        scope.find(params[:id])
      end

      def collection
        return @collection if @collection.present?

        params[:q] ||= {}
        @collection = scope

        @search = @collection.ransack(params[:q])
        @collection = @search.result.page(params[:page]).per(params[:per_page])
      end

      def location_after_save
        aypex.edit_admin_cms_page_path(@cms_page)
      end
    end
  end
end

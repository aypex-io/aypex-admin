module Aypex
  module Admin
    class CmsSectionsController < ResourceController
      belongs_to "aypex/cms_page"

      def update_position
        if @object.update(position: permitted_resource_params[:position])
          respond_to do |format|
            format.turbo_stream
          end
        else
          stream_flash_alert(message: I18n.t("aypex.admin.position_could_not_be_updated"), kind: :error)
        end
      end

      private

      def collection_url
        aypex.edit_admin_cms_page_path(@cms_page)
      end

      def location_after_save
        aypex.edit_admin_cms_page_cms_section_path(@cms_page, @cms_section)
      end
    end
  end
end

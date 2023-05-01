module Aypex
  module Admin
    class CmsComponentsController < ResourceController
      belongs_to "aypex/cms_section"

      def update_position
        if @object.update(position: permitted_resource_params[:position])
          respond_to do |format|
            format.turbo_stream
          end
        else
          stream_flash_alert(message: I18n.t("aypex.admin.position_could_not_be_updated"), kind: :error)
        end
      end
    end
  end
end

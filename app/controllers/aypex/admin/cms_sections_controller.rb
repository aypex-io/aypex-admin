module Aypex
  module Admin
    class CmsSectionsController < ResourceController
      belongs_to "aypex/cms_page"

      def edit
        ensure_sections

        super
      end

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

      def ensure_sections
        # i = 0
        # loop do
        #   break if @object.default_number_of_components <= 0

        #   i += 1

        #   @object.cms_components
        #     .where(position: i,
        #            type: "Aypex::Cms::Component::#{@object.class.name.demodulize}",
        #            linked_resource_type: @object.default_linked_recource_for_component)
        #     .first_or_create

        #   break if i == @object.default_number_of_components
        # end
      end

      def collection_url
        aypex.edit_admin_cms_page_path(@cms_page)
      end

      def location_after_save
        aypex.edit_admin_cms_page_cms_section_path(@cms_page, @cms_section)
      end
    end
  end
end

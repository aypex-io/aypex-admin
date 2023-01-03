module Aypex
  module Admin
    class OptionTypesController < ResourceController
      protected

      def location_after_save
        aypex.edit_admin_option_type_url(@option_type)
      end
    end
  end
end

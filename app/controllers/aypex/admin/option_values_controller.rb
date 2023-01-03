module Aypex
  module Admin
    class OptionValuesController < ResourceController
      belongs_to "aypex/option_type"

      def location_after_save
        aypex.edit_admin_option_type_url(@option_type)
      end
    end
  end
end

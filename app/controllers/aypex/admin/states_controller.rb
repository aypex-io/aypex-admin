module Aypex
  module Admin
    class StatesController < ResourceController
      belongs_to "aypex/country"

      private

      def location_after_save
        aypex.edit_admin_country_path(@country)
      end
    end
  end
end

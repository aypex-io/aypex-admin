module Aypex
  module Admin
    class BaseCategoriesController < ResourceController
      private

      def location_after_save
        if @base_category.previously_new_record?
          aypex.edit_admin_base_category_url(@base_category)
        else
          aypex.admin_base_categories_url
        end
      end
    end
  end
end

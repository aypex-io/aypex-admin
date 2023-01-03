module Aypex
  module Admin
    class TaxonomiesController < ResourceController
      private

      def location_after_save
        if @taxonomy.previously_new_record?
          aypex.edit_admin_taxonomy_url(@taxonomy)
        else
          aypex.admin_taxonomies_url
        end
      end
    end
  end
end

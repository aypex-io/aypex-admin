module Aypex
  module Admin
    class VariantsIncludingMasterController < VariantsController
      belongs_to "aypex/product", find_by: :slug

      def model_class
        Aypex::Variant
      end

      def object_name
        "variant"
      end
    end
  end
end

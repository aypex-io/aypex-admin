module Aypex
  module Admin
    module ImagesHelper
      def options_text_for(image)
        if image.viewable.is_a?(Aypex::Variant)
          if image.viewable.is_master?
            Aypex.t(:all)
          else
            image.viewable.sku_and_options_text
          end
        else
          Aypex.t(:all)
        end
      end
    end
  end
end

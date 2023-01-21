module Aypex
  module Admin
    module ImagesHelper
      def options_text_for(image)
        if image.viewable.is_a?(Aypex::Variant)
          if image.viewable.is_master?
            I18n.t("aypex.admin.all")
          else
            image.viewable.sku_and_options_text
          end
        else
           I18n.t("aypex.admin.all")
        end
      end
    end
  end
end

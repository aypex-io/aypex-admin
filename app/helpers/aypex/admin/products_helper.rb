module Aypex
  module Admin
    module ProductsHelper
      def product_image_tag(product, options = {})
        image = default_image_for_product(product)

        img = if image.present?
          options[:alt] = image.alt.blank? ? product.name : image.alt

          image_tag(image.generate_url(size: "100x100"), options)
        else
          aypex_admin_svg_tag "missing-image.svg", class: "noimage", size: "60%*60%"
        end

        content_tag(:div, img, class: "product-image-inner")
      end

      # will return a human readable string
      def available_status(product)
        return I18n.t("aypex.admin.archived") if product.status == "archived"
        return I18n.t("aypex.admin.deleted") if product.deleted?

        if product.available?
          I18n.t("aypex.admin.active")
        else
          I18n.t("aypex.admin.draft")
        end
      end
    end
  end
end

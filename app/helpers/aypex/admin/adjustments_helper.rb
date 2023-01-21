module Aypex
  module Admin
    module AdjustmentsHelper
      def display_adjustable(adjustable)
        case adjustable
        when Aypex::LineItem
          display_line_item(adjustable)
        when Aypex::Shipment
          display_shipment(adjustable)
        when Aypex::Order
          display_order(adjustable)
        end
      end

      private

      def display_line_item(line_item)
        variant = line_item.variant
        parts = []
        parts << variant.product.name
        parts << "(#{variant.options_text})" if variant.options_text.present?
        parts << line_item.display_total
        safe_join(parts, "<br />".html_safe)
      end

      def display_shipment(shipment)
        "#{I18n.t("aypex.admin.shipment")} ##{shipment.number}<br>#{shipment.display_cost}".html_safe
      end

      def display_order(_order)
        I18n.t("aypex.admin.order")
      end
    end
  end
end

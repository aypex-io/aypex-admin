module Aypex
  module Admin
    module StoresHelper
      def selected_checkout_zone(store)
        store&.checkout_zone || Aypex::Zone.default_checkout_zone
      end

      def stores_dropdown_values
        formatted_stores = []

        @stores.map { |store| formatted_stores << [store.unique_name, store.id] }

        formatted_stores
      end

      def store_switcher_link(store)
        if current_store.id == store.id
          classes = "disabled bg-light"
          icon = aypex_admin_svg_tag "circle-fill.svg", size: "18px * 18px"
        else
          classes = nil
          icon = aypex_admin_svg_tag "circle.svg", size: "18px * 18px"
        end

        link_to icon + store.unique_name, aypex.admin_url(host: store.formatted_url),
          class: "#{classes} py-3 px-4 dropdown-item rounded", id: store.code, data: {turbo: false}
      end
    end
  end
end

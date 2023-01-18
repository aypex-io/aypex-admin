module Aypex
  module Admin
    module StoreDecorator
      def self.prepended(base)
        base.typed_store :aypex_admin_settings, coder: ActiveRecord::TypedStore::IdentityCoder do |s|
          s.integer :admin_products_per_page, default: 25, null: false
          s.integer :admin_orders_per_page, default: 25, null: false
          s.integer :admin_properties_per_page, default: 25, null: false
          s.integer :admin_promotions_per_page, default: 25, null: false
          s.integer :admin_customer_returns_per_page, default: 25, null: false
          s.integer :admin_users_per_page, default: 25, null: false
          s.integer :admin_variants_per_page, default: 25, null: false
          s.integer :admin_menus_per_page, default: 25, null: false

          s.boolean :admin_show_version, default: true, null: true
          s.boolean :admin_product_wysiwyg_editor_enabled, default: true, null: true

          s.boolean :admin_category_wysiwyg_editor_enabled, default: true, null: true
          s.boolean :admin_show_only_complete_orders_by_default, default: true, null: true
        end
      end

      ::Aypex::Store.prepend self if ::Aypex::Store.included_modules.exclude?(self)
    end
  end
end

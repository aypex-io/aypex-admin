class AddAdminAypexAdminSettingsToAypexStores < ActiveRecord::Migration[7.0]
  def change
    change_table :aypex_stores do |t|
      if t.respond_to? :jsonb
        add_column :aypex_stores, :aypex_admin_settings, :jsonb
      else
        add_column :aypex_stores, :aypex_admin_settings, :json
      end
    end
  end
end

class AddVendorIdToOrder < ActiveRecord::Migration[7.1]
  def change
    add_column :spree_orders, :vendor_id, :bigint
  end
end

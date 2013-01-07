class AddProductKeyToDataItem < ActiveRecord::Migration
  def change
    add_column :data_items, :product_id, :integer
  end
end

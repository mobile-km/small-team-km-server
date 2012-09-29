class AddDeltaToDataLists < ActiveRecord::Migration
  def change
    add_column :data_lists, :delta, :boolean, :default => true, :null => false
  end
end

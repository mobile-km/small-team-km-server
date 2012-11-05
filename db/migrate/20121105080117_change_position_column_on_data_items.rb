class ChangePositionColumnOnDataItems < ActiveRecord::Migration
  def change
    change_column :data_items, :position, :string
  end
end

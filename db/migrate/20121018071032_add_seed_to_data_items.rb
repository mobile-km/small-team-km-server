class AddSeedToDataItems < ActiveRecord::Migration
  def change
    add_column(:data_items, :seed, :string) 
  end
end

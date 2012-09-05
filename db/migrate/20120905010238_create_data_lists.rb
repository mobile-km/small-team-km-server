class CreateDataLists < ActiveRecord::Migration
  def change
    create_table :data_lists do |t|
      t.integer :creator_id
      t.string  :title
      t.string  :kind  # COLLECTION STEP
      t.boolean :public  # true false
      t.timestamps
    end
  end
end

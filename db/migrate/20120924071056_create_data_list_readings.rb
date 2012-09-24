class CreateDataListReadings < ActiveRecord::Migration
  def change
    create_table :data_list_readings do |t|
      t.integer :data_list_id
      t.integer :user_id
      t.timestamps
    end
  end
end

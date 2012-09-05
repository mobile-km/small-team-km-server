class CreateDataItems < ActiveRecord::Migration
  def change
    create_table :data_items do |t|
      t.string  :title
      t.text    :content
      t.string  :url
      t.integer :file_entity_id
      t.string  :kind  # URL TEXT IMAGE
      t.integer :data_list_id
      t.integer :position
      t.timestamps
    end
  end
end

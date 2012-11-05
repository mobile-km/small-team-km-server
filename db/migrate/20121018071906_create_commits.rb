class CreateCommits < ActiveRecord::Migration
  def change
    create_table :commits do |t|
      t.integer :forked_data_list_id
      t.string :operation
      t.string :seed
      t.string :title
      t.text :content
      t.string :url
      t.integer :file_entity_id
      t.string :kind
      t.timestamps
    end
  end
end

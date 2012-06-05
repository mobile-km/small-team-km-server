class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :uuid
      t.integer :creator_id
      t.text :content
      t.string :kind

      t.boolean :is_removed
      t.timestamps

      t.string :attachment_file_name
      t.integer :attachment_file_size
      t.string :attachment_content_type
      t.datetime :attachment_updated_at
    end
  end
end

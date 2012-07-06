class CreateChatNodes < ActiveRecord::Migration
  def change
    create_table :chat_nodes do |t|
      t.integer :sender_id
      t.integer :chat_id
      t.string :content
      t.string :kind

      t.string :attachment_file_name
      t.integer :attachment_file_size
      t.string :attachment_content_type
      t.datetime :attachment_updated_at

      t.timestamps
    end
  end
end

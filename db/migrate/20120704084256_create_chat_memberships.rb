class CreateChatMemberships < ActiveRecord::Migration
  def change
    create_table :chat_memberships do |t|
      t.integer :chat_id
      t.integer :user_id
      t.timestamps
    end
  end
end

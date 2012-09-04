class CreateAttitudes < ActiveRecord::Migration
  def change
    create_table :attitudes do |t|
      t.integer :chat_node_id
      t.integer :user_id
      t.string :kind
      t.timestamps
    end
  end
end

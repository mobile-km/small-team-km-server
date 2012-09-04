class AddUuidColumnToChatsAndChatNodes < ActiveRecord::Migration
  def change
    add_column :chats, :uuid, :string
    add_column :chat_nodes, :uuid, :string
  end
end

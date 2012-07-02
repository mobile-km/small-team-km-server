class RemoveContactsAndContactInvites < ActiveRecord::Migration
  def change
    drop_table :contacts
    drop_table :contact_invites
  end
end

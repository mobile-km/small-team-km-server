class CreateContactsTable < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.integer :user_id
      t.integer :contact_user_id
      t.string :message
      t.string :status
      t.timestamps
    end
  end
end

class AddIsShowTipToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_show_tip, :boolean, :default => true
  end
end

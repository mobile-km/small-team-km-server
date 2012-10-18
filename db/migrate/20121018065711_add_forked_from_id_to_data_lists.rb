class AddForkedFromIdToDataLists < ActiveRecord::Migration
  def change
    add_column(:data_lists, :forked_from_id, :integer) 
  end
end

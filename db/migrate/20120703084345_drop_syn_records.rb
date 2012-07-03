class DropSynRecords < ActiveRecord::Migration
  def change
    drop_table :syn_records
  end
end

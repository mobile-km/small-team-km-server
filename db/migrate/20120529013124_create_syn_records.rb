class CreateSynRecords < ActiveRecord::Migration
  def change
    create_table :syn_records do |t|
      t.string :syn_task_uuid
      t.string :note_uuid
      t.timestamps
    end
  end
end

class CreateVersionChangeLogs < ActiveRecord::Migration
  def change
    create_table :version_change_logs do |t|
      t.string :version
      t.string :usable_oldest_version
      t.text :change_log
      t.timestamps
    end
  end
end

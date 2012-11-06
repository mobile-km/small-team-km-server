class AddPositionToCommits < ActiveRecord::Migration
  def change
    add_column :commits, :position, :string
  end
end

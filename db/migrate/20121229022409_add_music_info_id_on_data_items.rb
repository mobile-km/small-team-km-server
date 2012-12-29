class AddMusicInfoIdOnDataItems < ActiveRecord::Migration
  def change
    add_column(:data_items, :music_info_id, :integer)
  end
end

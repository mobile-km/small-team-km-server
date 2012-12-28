class ChangeSongTitle < ActiveRecord::Migration
  def change
    rename_column :music_infos, :song_title, :music_title
  end
end

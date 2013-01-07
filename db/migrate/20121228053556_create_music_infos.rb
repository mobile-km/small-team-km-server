class CreateMusicInfos < ActiveRecord::Migration
  def change
    create_table :music_infos do |t|
      t.string :song_title
      t.string :album_title
      t.string :author_name
      t.text   :cover_src
      t.text   :listen_location

      t.timestamps
    end
  end
end

class ChangeListenLocation < ActiveRecord::Migration
  def change
    rename_column :music_infos, :listen_location, :file_url
  end
end

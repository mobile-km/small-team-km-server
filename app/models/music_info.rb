class MusicInfo < ActiveRecord::Base
  validates :song_title, :album_title, :author_name, :presence => true
end

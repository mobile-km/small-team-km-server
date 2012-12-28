class MusicInfo < ActiveRecord::Base
  validates :album_title, :author_name, :presence => true

  validates :song_title, :presence => true,
            :uniqueness => {:scope => [:album_title, :author_name]}
end

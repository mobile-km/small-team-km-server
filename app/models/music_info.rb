class MusicInfo < ActiveRecord::Base
  validates :album_title, :author_name, :presence => true

  validates :music_title, :presence => true,
            :uniqueness => {:scope => [:album_title, :author_name]}
end

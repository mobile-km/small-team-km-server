class MusicInfo < ActiveRecord::Base
  validates :album_title, :author_name, :presence => true

  validates :music_title, :presence => true,
            :uniqueness => {:scope => [:album_title, :author_name]}



  def self.get_by_info(item)
    MusicInfo.where(
      :music_title => item[:music_title],
      :album_title => item[:album_title],
      :author_name => item[:author_name]
    ).first
  end


end

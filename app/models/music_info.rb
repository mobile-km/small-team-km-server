class MusicInfo < ActiveRecord::Base
  validates :album_title, :author_name, :presence => true

  validates :music_title, :presence => true,
            :uniqueness => {:scope => [:album_title, :author_name]}

  scope :find_items, (lambda do |key|
    where("album_title like '%#{key}%' or author_name like '%#{key}%' or music_title like '%#{key}%' ")
  end)


  def self.get_by_info(item)
    MusicInfo.where(
      :music_title => item[:music_title],
      :album_title => item[:album_title],
      :author_name => item[:author_name]
    ).first
  end


end

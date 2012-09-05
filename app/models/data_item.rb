class DataItem < ActiveRecord::Base
  TEXT_KIND  = 'TEXT_KIND'
  IMAGE_KIND = 'IMAGE_KIND'
  URL_KIND   = 'URL_KIND'
  KINDS = [ TEXT_KIND, IMAGE_KIND, URL_KIND ]

  belongs_to :data_list
  belongs_to :file_entity

  validates :title,        :presence => true
  validates :position,     :presence => true
  validates :data_list_id, :presence => true
  validates :kind,         :presence => true, :inclusion => DataItem::KINDS

  validates :content,        :presence => lambda {|data_item| data_item.kind == DataItem::TEXT_KIND}
  validates :file_entity_id, :presence => lambda {|data_item| data_item.kind == DataItem::IMAGE_KIND}
  validates :url,            :presence => lambda {|data_item| data_item.kind == DataItem::URL_KIND}
end

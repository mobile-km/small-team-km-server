class DataItem < ActiveRecord::Base
  KIND_TEXT  = 'TEXT'
  KIND_IMAGE = 'IMAGE'
  KIND_URL   = 'URL'
  KINDS = [ KIND_TEXT, KIND_IMAGE, KIND_URL ]

  belongs_to :data_list
  belongs_to :file_entity

  validates :title,        :presence => true
  validates :position,     :presence => true
  validates :data_list_id, :presence => true
  validates :kind,         :presence => true, :inclusion => DataItem::KINDS

  validates :content,        :presence => lambda {|data_item| data_item.kind == DataItem::KIND_TEXT}
  validates :file_entity_id, :presence => lambda {|data_item| data_item.kind == DataItem::KIND_IMAGE}
  validates :url,            :presence => lambda {|data_item| data_item.kind == DataItem::KIND_URL}

  # 列表项标题重复异常
  class TitleRepeatError < Exception; end;

  # 列表项URL重复异常
  class UrlRepeatError < Exception; end;

end

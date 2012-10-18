# acts_as_list-rails3 加载有问题，暂时只能手动 require 一下，才能用
require 'acts_as_list'

class DataItem < ActiveRecord::Base
  KIND_TEXT  = 'TEXT'
  KIND_IMAGE = 'IMAGE'
  KIND_URL   = 'URL'
  KINDS = [ KIND_TEXT, KIND_IMAGE, KIND_URL ]

  belongs_to :data_list
  belongs_to :file_entity

  acts_as_list :scope => :data_list

  validates :title,        :presence => true,
    :uniqueness => {:scope => :data_list_id}
  validates :data_list_id, :presence => true
  validates :kind,         :presence => true, :inclusion => DataItem::KINDS

  validates :content,        :presence => {:if => lambda {|data_item| data_item.kind == DataItem::KIND_TEXT}}
  validates :file_entity,    :presence => {:if => lambda {|data_item| data_item.kind == DataItem::KIND_IMAGE}}
  validates :url,            :presence => {:if => lambda {|data_item| data_item.kind == DataItem::KIND_URL}},
    :uniqueness => {:scope => :data_list_id}

  after_save :set_data_list_delta_flag
  after_destroy :set_data_list_delta_flag
  def set_data_list_delta_flag
    data_list.delta = true
    data_list.save
  end

  after_save :set_data_list_updated_at
  after_destroy :set_data_list_updated_at
  def set_data_list_updated_at
    data_list.touch
  end

  # 列表项标题重复异常
  class TitleRepeatError < Exception; end;

  # 列表项URL重复异常
  class UrlRepeatError < Exception; end;

  def to_hash
    return {
      :id         => self.id,
      :title      => self.title,
      :kind       => self.kind,
      :position   => self.position,
      :content    => self.content,
      :url        => self.url,
      :image_url  => self.file_entity.blank? ? "" : self.file_entity.attach.url,
      :data_list => {
        :server_updated_time => self.data_list.updated_at.to_i
      }
    }
  end

  def update_by_params(param_title, param_value)
    attrs = {}
    attrs[:title] = param_title if !param_title.blank?

    case self.kind
    when DataItem::KIND_TEXT
      attrs[:content] = param_value if !param_value.blank?
    when DataItem::KIND_IMAGE
      attrs[:file_entity] = FileEntity.new(:attach => param_value) if !param_value.blank?
    when DataItem::KIND_URL
      attrs[:url] = param_value if !param_value.blank?
    end

    self.update_attributes(attrs)

    if !self.valid?
      raise DataItem::TitleRepeatError if self.errors.first[0] == :title && !self.title.blank?

      raise DataItem::UrlRepeatError if self.errors.first[0] == :url && !self.url.blank?
    end
  end

  def get_or_create_seed
    raise 'new_record is not support' if self.id.blank?

    if self.seed.blank?
      DataItem.where(:id=>self.id).update_all(:seed=>randstr)
      self.reload
    end

    self.seed
  end

end

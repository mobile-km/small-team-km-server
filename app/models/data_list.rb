class DataList < ActiveRecord::Base
  KIND_COLLECTION = 'COLLECTION'
  KIND_STEP       = 'STEP'
  KINDS = [ KIND_COLLECTION, KIND_STEP ]

  has_many :data_items, :order => "position"
  belongs_to :creator, :class_name => 'User'

  validates :title, :presence => true
  validates :kind,  :presence => true, :inclusion => DataList::KINDS

  scope :with_kind_collection, where(:kind => KIND_COLLECTION)
  scope :with_kind_step, where(:kind => KIND_STEP)

  def to_hash
    return {
      :id         => self.id,
      :creator_id => self.creator_id,
      :title      => self.title,
      :kind       => self.kind,
      :public     => self.public?.to_s
    }
  end

  # 创建列表项
  def create_item(kind, title, value)
    item = case kind
    when DataItem::KIND_TEXT
      self.data_items.create(:kind => DataItem::KIND_TEXT, :title => title, :content => value)
    when DataItem::KIND_IMAGE
      self.data_items.create(:kind => DataItem::KIND_IMAGE, :title => title, :file_entity => FileEntity.new(:attach => value))
    when DataItem::KIND_URL
      self.data_items.create(:kind => DataItem::KIND_URL, :title => title, :url => value)
    end

    if !item.valid?
      raise DataItem::TitleRepeatError if item.errors.first[0] == :title && !item.title.blank?

      raise DataItem::UrlRepeatError if item.errors.first[0] == :url && !item.url.blank?
    end
    item
  end

  module UserMethods
    def self.included(base)
      base.has_many :data_lists,
                    :foreign_key => :creator_id

      base.send :include, InstanceMethods
    end

    module InstanceMethods
    end
  end

  define_index do
    indexes title, :sortable => true
    indexes data_items(:title)
    indexes data_items(:content)

    has creator_id
  end
end

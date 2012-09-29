class DataList < ActiveRecord::Base
  KIND_COLLECTION = 'COLLECTION'
  KIND_STEP       = 'STEP'
  KINDS = [ KIND_COLLECTION, KIND_STEP ]

  has_many :data_items, :order => "position"
  belongs_to :creator, :class_name => 'User'
  has_many :data_list_readings

  has_many :watchs
  has_many :watch_users, :through => :watchs, :source => :user

  validates :title, :presence => true
  validates :kind,  :presence => true, :inclusion => DataList::KINDS

  scope :with_kind_collection, where(:kind => KIND_COLLECTION)
  scope :with_kind_step, where(:kind => KIND_STEP)
  scope :public_timeline, where(:public => true).order('updated_at DESC')

  def to_hash
    return {
      :id         => self.id,
      :title      => self.title,
      :kind       => self.kind,
      :public     => self.public?.to_s,
      :creator => {
        :id => self.creator.id,
        :name => self.creator.name,
        :avatar_url => self.creator.logo.url,
        :server_created_time => self.creator.created_at.to_i,
        :server_updated_time => self.creator.updated_at.to_i
      },
      :server_created_time => self.created_at.to_i,
      :server_updated_time => self.updated_at.to_i
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
    self.touch
    item
  end

  def read(user)
    self.data_list_readings.find_or_create_by_user_id(user.id)
  end

  def read?(user)
    !self.data_list_readings.find_by_user_id(user.id).blank?
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
    has public
    has watchs(:user_id), :as => :watch_user_ids
    set_property :delta => true
  end
end

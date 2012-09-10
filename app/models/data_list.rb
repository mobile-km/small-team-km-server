class DataList < ActiveRecord::Base
  KIND_COLLECTION = 'COLLECTION'
  KIND_STEP       = 'STEP'
  KINDS = [ KIND_COLLECTION, KIND_STEP ]

  has_many :data_items
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
    # TODO
    # 根据传入的kind来确定给什么字段赋值，统一封装来简化controller调用。
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
end

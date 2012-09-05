class DataList < ActiveRecord::Base
  COLLECTION_KIND = 'COLLECTION_KIND'
  STEP_KIND       = 'STEP_KIND'
  KINDS = [ COLLECTION_KIND, STEP_KIND ]

  has_many :data_items
  belongs_to :creator, :class_name => 'User'

  validates :title, :presence => true
  validates :kind,  :presence => true, :inclusion => DataList::KINDS
end

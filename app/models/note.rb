class Note < ActiveRecord::Base
  class Kind
    TEXT = "TEXT";
    IMAGE = "IMAGE";
  end

  belongs_to :creator, :class_name=>"User"

  has_attached_file :attachment,
    :path => '/:class/:attachment/:id/:style/:filename',
    :url  => "http://storage.aliyun.com/#{OssManager::CONFIG["bucket"]}/:class/:attachment/:id/:style/:filename",
    :storage => :oss

  module UserMethods
    def self.included(base)
      base.has_many :notes,:foreign_key=>:creator_id
    end
  end
end

class ChatNode < ActiveRecord::Base
  class Kind
    TEXT = "TEXT"
    IMAGE = "IMAGE"
  end

  belongs_to :sender, :class_name=>"User"
  belongs_to :chat

  has_attached_file :attachment,
    :path => '/:class/:attachment/:id/:style/:filename',
    :url  => "http://storage.aliyun.com/#{OssManager::CONFIG["bucket"]}/:class/:attachment/:id/:style/:filename",
    :storage => :oss

  def to_hash
    {
      :server_chat_node_id=>self.id,
      :sender_id=>self.sender_id,
      :content=>self.content,
      :kind=>self.kind,
      :attachment_url=>self.attachment.url,
      :server_created_time=>self.created_at.to_i
    }
  end

  module UserMethods
    def self.included(base)
      base.has_many :send_chat_nodes, :class_name=>"ChatNode", :foreign_key=>:sender_id
    end
  end
end

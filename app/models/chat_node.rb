class ChatNode < ActiveRecord::Base
  class Kind
    TEXT = "TEXT"
    IMAGE = "IMAGE"
  end

  belongs_to :sender, :class_name=>"User"
  belongs_to :chat

  validates :uuid, :presence => true

  validates :content,
    :presence => { :if=>Proc.new{|chat_node|chat_node.kind == Kind::TEXT} }
  validates :kind, :presence => true,
    :inclusion => [Kind::TEXT,Kind::IMAGE]

  validates :sender, :presence => true
  validates :chat, :presence => true

  has_attached_file :attachment,
    :path => '/:class/:attachment/:id/:style/:filename',
    :url  => "http://storage.aliyun.com/#{OssManager::CONFIG["bucket"]}/:class/:attachment/:id/:style/:filename",
    :storage => :oss

  has_many :attitudes

  def to_hash
    {
      :uuid=>self.uuid,
      :server_chat_id=>self.chat_id,
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

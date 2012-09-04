class Attitude < ActiveRecord::Base
  class Kind
    GASP  = "GASP"
    HEART = "HEART"
    SAD   = "SAD"
    SMILE = "SMILE"
    WINK  = "WINK"
  end

  belongs_to :chat_node
  belongs_to :user

  validates :chat_node, :presence => true
  validates :user, :presence => true
  validates :kind, :presence => true,
    :inclusion => [Kind::GASP, Kind::HEART, Kind::SAD, Kind::SMILE, Kind::WINK]

  def to_hash
    {
      :server_chat_node_id=>self.chat_node_id,
      :user=>{
        :user_id=>self.user.id,
        :user_name=>self.user.name,
        :user_avatar_url=>self.user.logo.url,
        :server_created_time=>self.user.created_at.to_i,
        :server_updated_time=>self.user.updated_at.to_i
      },
      :kind=>self.kind,
      :server_updated_time=>self.updated_at.to_i
    }
  end

  module UserMethods
    def self.included(base)
      base.has_many :attitudes
      base.has_many :recevied_attitudes, :through=> :recevied_chat_nodes, :source=>:attitudes
    end
  end
end

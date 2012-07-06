class Chat < ActiveRecord::Base
  has_many :chat_memberships
  has_many :chat_members, :through=>:chat_memberships, :source=>:user

  has_many :chat_nodes


  def to_hash
    members = self.chat_members.map.each do |user|
      {
        :user_id=>user.id,
        :user_name=>user.name,
        :user_avatar=>user.avatar,
        :server_created_time=>user.created_at.to_i,
        :server_updated_time=>user.updated_at.to_i
      }
    end
    return {
      :server_chat_id=>self.id,
      :server_created_time=>self.created_at.to_i,
      :server_updated_time=>self.updated_at.to_i,
      :members=>members
    }
  end
end

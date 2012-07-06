class ChatMembership < ActiveRecord::Base
  belongs_to :chat
  belongs_to :user

  validates :chat, :presence => true
  validates :user, :presence => true

  module UserMethods
    def self.included(base)
      base.has_many :chat_memberships
      base.has_many :joined_chats, :through=>:chat_memberships, :source=>:chat
    end
  end
end

class Follow < ActiveRecord::Base
  belongs_to :user
  belongs_to :follow_user, :class_name => 'User'

  validates :user_id, :presence => true
  validates :follow_user_id, :presence => true,
    :uniqueness => {:scope => :user_id}

  module UserMethods
    def self.included(base)
      base.has_many :follows
      base.has_many :follow_users, :through => :follows, :source => :follow_user
    end

    def follow(follow_user)
      return if self.follow_users.include?(follow_user)
      self.follows.create :follow_user => follow_user
    end
  end
end

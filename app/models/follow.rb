class Follow < ActiveRecord::Base
  belongs_to :user
  belongs_to :follow_user, :class_name => 'User'

  validates :user_id, :presence => true
  validates :follow_user_id, :presence => true,
    :uniqueness => {:scope => :user_id}

  module UserMethods
    def self.included(base)
      base.has_many :follows
      base.has_many :follow_users_db, :through => :follows, :source => :follow_user

      base.has_many :fan_follows, :class_name => 'Follow', :foreign_key => :follow_user_id
      base.has_many :fan_users_db, :through => :fan_follows, :source => :user
    end

    def follow(follow_user)
      return if self.follow_users.include?(follow_user)
      self.follows.create :follow_user => follow_user
    end

    def unfollow(follow_user)
      follow = self.follows.find_by_follow_user_id(follow_user.id)
      follow.destroy if !follow.blank?
    end

    def followed?(follow_user)
      self.follow_users_db.include?(follow_user)
    end

  end
end

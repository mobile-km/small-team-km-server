class UserFollowUsersProxy < RedisBaseProxy
  def initialize(user)
    @user = user
    @key = "user_#{user.id}_follow_users"
  end

  def xxxs_ids_db
    @user.follow_users_db.map{|user|user.id}
  end

  def self.rules
    {
      :class => Follow ,
      :after_create => Proc.new {|follow|
        UserFollowUsersProxy.new(follow.user).add_to_cache(follow.follow_user_id)
      },
      :after_destroy => Proc.new {|follow|
        UserFollowUsersProxy.new(follow.user).remove_from_cache(follow.follow_user_id)
      }
    }
  end

  def self.funcs
    {
      :class  => User ,
      :follow_users => Proc.new {|user|
        UserFollowUsersProxy.new(user).get_models(User)
      }
    }
  end
end
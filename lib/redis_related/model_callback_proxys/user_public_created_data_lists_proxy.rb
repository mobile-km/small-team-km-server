class UserPublicCreatedDataListsProxy
  def initialize(user)
    @user = user
    @key = "user_#{user.id}_public_created_data_lists"
    @redis = RedisCache.instance
  end

  def data_list_ids(timestamp,count)
    reload_cache_if_unexist
    max = timestamp.blank? ? '+inf' : "(#{timestamp}"
    @redis.zrevrangebyscore(@key, max, '-inf', :with_scores => true)[0...count]
  end

  def add_to_cache(id,updated_at)
    reload_cache_if_unexist
    @redis.zadd(@key, updated_at, id)
  end

  def remove_from_cache(id)
    reload_cache_if_unexist
    @redis.zrem(@key, id)
  end

  def self.after_save(data_list)
    creator = data_list.creator
    id = data_list.id
    if data_list.public?
      updated_at = data_list.updated_at.to_i
      UserPublicCreatedDataListsProxy.new(creator).add_to_cache(id, updated_at)
    else
      UserPublicCreatedDataListsProxy.new(creator).remove_from_cache(id)
    end
  end

  def self.rules
    {
      :class => DataList ,
      :after_create => Proc.new {|data_list|
        UserPublicCreatedDataListsProxy.after_save(data_list)
      },
      :after_update => Proc.new {|data_list|
        UserPublicCreatedDataListsProxy.after_save(data_list)
      },
      :after_destroy => Proc.new {|data_list|
        creator = data_list.creator
        id = data_list.id
        UserPublicCreatedDataListsProxy.new(creator).remove_from_cache(id)
      }
    }
  end

  def self.funcs
    []
  end

  private
  def reload_cache_if_unexist
    return if @redis.exists(@key)

    @user.data_lists.public_timeline.each do |data_list|
      updated_at = data_list.updated_at.to_i
      @redis.zadd(@key, updated_at, data_list.id)
    end
  end
end
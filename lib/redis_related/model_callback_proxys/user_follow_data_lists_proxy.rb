class UserFollowDataListsProxy
  def self.rules
    []
  end

  def self.funcs
    {
      :class  => User ,
      :follow_data_lists => Proc.new {|user,timestamp|
        count = 30
        ids = []
        user.follow_users_db.each do |u|
          ids += UserPublicCreatedDataListsProxy.new(u).data_list_ids(timestamp,count)
        end
        ids.sort{|c,d|d[1]<=>c[1]}[0...count].map{|id|DataList.find_by_id(id)}.compact
      }
    }
  end
end
class UserFollowDataListsProxy
  def self.rules
    []
  end

  def self.funcs
    {
      :class  => User ,
      :follow_data_lists => Proc.new {|user,timestamp,per_page|
        per_page ||= 20
        per_page = per_page.to_i
        ids = []
        user.follow_users_db.each do |u|
          ids += UserPublicCreatedDataListsProxy.new(u).data_list_ids(timestamp,per_page)
        end
        ids.sort{|c,d|d[1]<=>c[1]}[0...per_page].map{|id|DataList.find_by_id(id)}.compact
      }
    }
  end
end
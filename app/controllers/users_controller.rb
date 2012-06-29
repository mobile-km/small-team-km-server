class UsersController < ApplicationController
  def search
    users = User.where(User.arel_table[:name].matches("%#{params[:query]}%"))
    result = users.map do |user|
      {
        :user_id=>user.id,
        :user_name=>user.name,
        :user_avatar_url=>user.logo.url,
        :contact_status=>current_user.contact_status?(user)
      }
    end
    render :json=>result
  end
end
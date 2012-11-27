class Api::UsersController < ApplicationController
  before_filter :login_required
  before_filter :per_load
  def per_load
    @user = User.find(params[:id]) if params[:id]
  end

  def show
    if @user != current_user
      json = {
        :user => @user.api0_json_hash,
        :followed => current_user.followed?(@user)
      }
    else
      json = {
        :user => @user.api0_json_hash
      }
    end
    render :json => json
  end

  def follow
    raise '不能 follow 自己' if @user == current_user

    current_user.follow(@user)
    render :text => 'success'
  end

  def unfollow
    raise '不能 follow 自己' if @user == current_user

    current_user.unfollow(@user)
    render :text => 'success'
  end

  def follows
    users = @user.follow_users_db.paginate(:page => params[:page],:per_page => params[:per_page]||20)
    json = users.map{ |user| user.api0_json_hash}
    render :json => json
  end

  def fans
    json = @user.fan_users_db.paginate(:page => params[:page],:per_page => params[:per_page]||20)
    json = users.map{ |user| user.api0_json_hash}
    render :json => json
  end

  def public_data_lists
    @data_lists = current_user.data_lists.public_timeline.paginate(:page => params[:page],:per_page => params[:per_page]||20)
    render(:json => @data_lists.map{ |data_list| data_list.to_hash })
  end

end
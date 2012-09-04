class Api::AccountController < ApplicationController
  before_filter :login_required

  def change_name
    current_user.name = params[:name]
    if current_user.save
      render :json=>current_user.api0_json_hash
    else
      error = current_user.errors.first
      render :text=>error[1],:status=>422
    end
  end

  def change_avatar
    current_user.logo = params[:avatar]
    if current_user.save
      render :json=>current_user.api0_json_hash
    else
      error = current_user.errors.first
      render :text=>error[1],:status=>422
    end
  end
end
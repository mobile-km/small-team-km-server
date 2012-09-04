class SignupController < ApplicationController
  include SessionsMethods
  
  # 注册
  def form
    return redirect_to('/') if logged_in?
    @user = User.new
  end
  
  # 创建
  def form_submit
    # 出于安全性考虑，新用户注册时销毁cookies令牌
    destroy_remember_me_cookie_token
    @user = User.new(params[:user])
    
    if @user.save
      self.current_user = @user
      after_logged_in()
      return render :json=>current_user.api0_json_hash
    end
    error = @user.errors.first
    render :json=>error[1],:status=>422
  end
end

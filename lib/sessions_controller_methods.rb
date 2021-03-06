# encoding: utf-8
module SessionsControllerMethods
  # 登录
  def new
    return redirect_back_or_default(root_url) if logged_in?
    return render :template=>'index/login'
  end
  
  def create
    self.current_user = User.authenticate(params[:email], params[:password])
    if logged_in?
      render :json=>current_user.api0_json_hash
    else
      render :status=>401, :text=>"用户认证失败"
    end
  end
  
  # 登出
  def destroy
    user = current_user
    
    if user
      reset_session_with_online_key()
      # 登出时销毁cookies令牌
      destroy_remember_me_cookie_token()
      destroy_online_record(user)
    end
    
    return redirect_to "/login"
  end
  

  def auth
    if logged_in?
      render :json=>current_user.api0_json_hash
    else
      render :status=>401, :text=>"用户认证失败"
    end
  end
end

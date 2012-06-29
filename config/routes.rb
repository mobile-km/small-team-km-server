Voteapp::Application.routes.draw do  
  # -- 用户登录认证相关 --
  root :to=>"index#index"
  
  get  '/login'  => 'sessions#new'
  post '/login'  => 'sessions#create'
  get  '/logout' => 'sessions#destroy'
  
  get  '/signup'        => 'signup#form'
  post '/signup_submit' => 'signup#form_submit'
  
  # -- 以下可以自由添加其他 routes 配置项
  
  get '/auth'    => 'sessions#auth'

  # -- 同步
  # 握手 url
  get '/syn/handshake'   => 'synchronous#handshake'
  post '/syn/compare'    => 'synchronous#compare'
  post '/syn/push'       => 'synchronous#push'
  post '/syn/push_image' => 'synchronous#push_image'
  get '/syn/get_next'    => 'synchronous#get_next'

  # -- 联系人
  get '/users/search'              => 'users#search'
  post '/contacts/invite'          => 'contacts#invite'
  post '/contacts/accept_invite'   => 'contacts#accept_invite'
  post '/contacts/refuse_invite'   => 'contacts#refuse_invite'
  delete '/contacts/remove'        => 'contacts#remove'
  get '/contacts/refresh_status'   => 'contacts#refresh_status'
end

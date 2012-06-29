Voteapp::Application.routes.draw do  
  # -- 用户登录认证相关 --
  root :to=>"index#index"
  
  get  '/login'  => 'sessions#new'
  post '/login'  => 'sessions#create'
  get  '/logout' => 'sessions#destroy'

  get  '/signup'        => 'signup#form'
  post '/signup_submit' => 'signup#form_submit'

  # -- 图片笔记相关 --
  get  '/notes/add_image'     => 'images#add',
       :as                    => :add_image
  post '/notes/collect_image' => 'images#collect',
       :as                    => :collect_image
  
  # -- 以下可以自由添加其他 routes 配置项
  
  get '/auth'    => 'sessions#auth'

  # -- 同步
  # 握手 url
  get '/syn/handshake'   => 'synchronous#handshake'
  post '/syn/compare'    => 'synchronous#compare'
  post '/syn/push'       => 'synchronous#push'
  post '/syn/push_image' => 'synchronous#push_image'
  get '/syn/get_next'    => 'synchronous#get_next'
end

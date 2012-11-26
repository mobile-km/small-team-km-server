Voteapp::Application.routes.draw do  
  # -- 用户登录认证相关 --
  root :to=>"index#index"
  
  get  '/login'  => 'sessions#new'
  post '/login'  => 'sessions#create'
  get  '/logout' => 'sessions#destroy'

  get  '/signup'        => 'signup#form'
  post '/signup_submit' => 'signup#form_submit'

  # -- 版本检查
  get '/check_version' => 'version#check_version'

  # -- 外部资源采集相关 --
  get  '/notes/add_image'     => 'images#add',
       :as                    => :add_image
  post '/notes/collect_image' => 'images#collect',
       :as                    => :collect_image
  
  get  '/notes/add_page'      => 'pages#add',
       :as                    => :add_page
  post '/notes/collect_page'  => 'pages#collect',
       :as                    => :collect_page

  # -- 以下可以自由添加其他 routes 配置项
  
  get '/auth'    => 'sessions#auth'

  # -- 同步
  # 握手 url
  get   '/syn/pull'        => 'synchronous#pull'
  post  '/syn/push'        => 'synchronous#push'
  post  '/syn/push_image'  => 'synchronous#push_image'
  get   '/syn/detail_meta' => 'synchronous#detail_meta'

  # -- 联系人
  get '/users/search'              => 'users#search'
  post '/contacts/invite'          => 'contacts#invite'
  post '/contacts/accept_invite'   => 'contacts#accept_invite'
  post '/contacts/refuse_invite'   => 'contacts#refuse_invite'
  delete '/contacts/remove'        => 'contacts#remove'
  get '/contacts/refresh_status'   => 'contacts#refresh_status'

  namespace :api do
    # -- 对话串
    post '/chats'                    => 'chats#create'
    post '/chat_nodes'               => 'chat_nodes#create'
    get '/pull_chats'                => 'chats#pull'
    get '/pull_chat_nodes'           => 'chat_nodes#pull'
    post '/attitudes/push'           => 'attitudes#push'
    get '/attitudes/pull'            => 'attitudes#pull'

    # -- 账号设置
    post '/account/change_name'    => 'account#change_name'
    post '/account/change_avatar'  => 'account#change_avatar'
    post '/account/change_show_tip'  => 'account#change_show_tip'

    # -- 列表
    resources :data_lists, :shallow => true do
      collection do
        get :search_mine
        get :search_public_timeline
        get :search_mine_watch
        get :public_timeline
        get :watch_list
        get :forked_list
        get :follows_list
      end

      member do
        get :diff
        put :share_setting
        put :watch_setting
        put :fork
        get :commit_meta_list
        put :accept_commits
        put :reject_commits
        get :next_commit
        put :accept_next_commit
        put :reject_next_commit
        put :accept_rest_commits
        put :reject_rest_commits
      end

      resources :data_items do
        member do
          put :order
        end
      end
    end

    resources :users do
      member do
        post :follow
        post :unfollow
        get :follows
        get :fans
      end
    end
  end
end

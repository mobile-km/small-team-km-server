class Api::DataListsController < ApplicationController
  before_filter :login_required

  def index
    case params[:kind]
    when 'ALL'
      @data_lists = current_user.data_lists
    when DataList::KIND_COLLECTION
      @data_lists = current_user.data_lists.with_kind_collection
    when DataList::KIND_STEP
      @data_lists = current_user.data_lists.with_kind_step
    end

    @data_lists = @data_lists.paginate(:page => params[:page],:per_page => params[:per_page]||20)

    render(:json => @data_lists.map{ |data_list| data_list.to_hash }) 
  end

  def create
    params[:data_list][:public] = (params[:data_list][:public] == "true")
    @data_list = current_user.data_lists.build(params[:data_list])

    if @data_list.save
      render :json => @data_list.to_hash
    else
      render :json => @data_list.errors[0][1], :status => 422
    end
  end

  def update
    @data_list = current_user.data_lists.find(params[:id])

    if @data_list.update_attribute(:title, params[:title])
      render :json => @data_list.to_hash
    else
      render :json => @data_list.errors[0][1], :status => 422
    end
  end

  def search_mine
    data_lists = DataList.search(params[:query],:with=>{:creator_id=>current_user.id})
    render :json => data_lists.map{|list|list.id}
  end

  def search_public_timeline
    data_lists = DataList.search(params[:query],:with=>{:public=>true})
    render :json => data_lists.map{|list|list.id}
  end

  def search_mine_watch
    data_lists = DataList.search(params[:query],:with_all=>{:watch_user_ids=>[current_user.id]})
    render :json => data_lists.map{|list|list.id}
  end

  def share_setting
    @data_list = current_user.data_lists.find_by_id(params[:id])
    return render :status => 403 if @data_list.blank?

    value = (params[:share] == "true") ? true : false
    @data_list.update_attribute(:public, value)
    render :status => 200, :text =>""
  end

  def public_timeline
    @data_lists = DataList.public_timeline.paginate(:page => params[:page],:per_page => params[:per_page]||20)
    render(:json => @data_lists.map{ |data_list| data_list.to_hash })
  end

  def watch_list
    @data_lists = current_user.watched_list.paginate(:page => params[:page],:per_page => params[:per_page]||20)
    render(:json => @data_lists.map{ |data_list| data_list.to_hash })
  end

  def watch_setting
    data_list = DataList.find(params[:id])

    watch = (params[:watch] == 'true') ? true : false
    if watch
      current_user.watch(data_list)
    else
      current_user.unwatch(data_list)
    end
    render :status => 200, :text =>""
  end
end
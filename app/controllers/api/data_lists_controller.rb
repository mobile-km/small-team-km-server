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

    if @data_list.update_attributes(:title => params[:title], :public => (params[:public] == 'true'))
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
    return render :status => 403, :text=>'' if @data_list.blank?

    value = (params[:share] == "true") ? true : false
    @data_list.update_attribute(:public, value)
    render :status => 200, :text =>''
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

  def fork
    data_list = DataList.find(params[:id])
    forked_data_list = current_user.fork(data_list)
    render :json => forked_data_list.to_hash
  end

  def forked_list
    @data_lists = current_user.forked_data_lists.paginate(:page => params[:page],:per_page => params[:per_page]||20)
    render(:json => @data_lists.map{ |data_list| data_list.to_hash })
  end

  def commit_meta_list
    data_list = DataList.find(params[:id])
    render :json => data_list.commit_meta_hash
  end

  def diff
    origin_data_list = DataList.find(params[:id])
    forked_data_list = origin_data_list.forks.find_by_creator_id(params[:committer_id])
    render :json => {
      :origin => {
        :data_list => origin_data_list.to_hash,
        :data_items => origin_data_list.data_items.map{|data_item|data_item.to_hash}
      },
      :forked => {
        :data_list => forked_data_list.to_hash,
        :data_items => forked_data_list.data_items.map{|data_item|data_item.to_hash}
      }
    }
  end

  def accept_commits
    origin_data_list = DataList.find(params[:id])
    forked_data_list = origin_data_list.forks.find_by_creator_id(params[:committer_id])

    merger = DataListMerger.new(forked_data_list)
    merger.accept_commits
    origin_data_list.reload
    render :json => origin_data_list.to_hash
  end

  def reject_commits
    origin_data_list = DataList.find(params[:id])
    forked_data_list = origin_data_list.forks.find_by_creator_id(params[:committer_id])

    merger = DataListMerger.new(forked_data_list)
    merger.reject_commits
    render :json => origin_data_list.to_hash
  end

  def next_commit
    origin_data_list = DataList.find(params[:id])
    forked_data_list = origin_data_list.forks.find_by_creator_id(params[:committer_id])    
    merger = DataListMerger.new(forked_data_list)
    commit = merger.next_commit
    render :json => {
      :next_commits_count => merger.get_commits.length,
      :next_commit => commit.blank? ? {} : commit.to_hash
    }
  end

  def accept_next_commit
    origin_data_list = DataList.find(params[:id])
    forked_data_list = origin_data_list.forks.find_by_creator_id(params[:committer_id])
    merger = DataListMerger.new(forked_data_list)
    data_item = merger.accept_next_commit
    commit = merger.next_commit
    render :json => {
      :data_item_server_id => data_item.id,
      :next_commits_count => merger.get_commits.length,
      :next_commit => commit.blank? ? {} : commit.to_hash
    }
  end

  def reject_next_commit
    origin_data_list = DataList.find(params[:id])
    forked_data_list = origin_data_list.forks.find_by_creator_id(params[:committer_id])
    merger = DataListMerger.new(forked_data_list)
    merger.reject_next_commit
    commit = merger.next_commit
    render :json => {
      :next_commits_count => merger.get_commits.length,
      :next_commit => commit.blank? ? {} : commit.to_hash
    }
  end
end
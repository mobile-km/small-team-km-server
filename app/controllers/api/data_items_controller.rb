class Api::DataItemsController < ApplicationController
  before_filter :login_required
  before_filter :per_load
  def per_load
    @data_item = DataItem.find(params[:id]) if params[:id]
    @data_list = DataList.find(params[:data_list_id]) if params[:data_list_id]
  end

  before_filter :check_acl,:only=>[:create,:update,:destroy,:order]
  def check_acl
    data_list = @data_list || @data_item.data_list
    if data_list.creator != current_user
      render :status => 403,:text => '没有权限'
    end
  end

  def index
    json = {
      :read => @data_list.read?(current_user),
      :has_commits => @data_list.has_commits?.to_s,
      :forked_from => @data_list.forked_from.blank? ? {} : {
        :creator => {
          :id => @data_list.forked_from.creator.id,
          :name => @data_list.forked_from.creator.name,
          :avatar_url => @data_list.forked_from.creator.logo.url,
          :server_created_time => @data_list.forked_from.creator.created_at.to_i,
          :server_updated_time => @data_list.forked_from.creator.updated_at.to_i
        }
      },
      :data_items => @data_list.data_items.map{|data_item|data_item.to_hash}
    }
    @data_list.read(current_user)
    render :json => json
  end

  def create
    if @data_list.forked_from.blank?
      _create_for_origin_list
    else
      _create_for_forked_list
    end
  end

  def _create_for_origin_list
    data_item = @data_list.create_item(params[:kind], params[:title], params[:value])
    render :json => data_item.to_hash
  rescue Exception => ex
    render :text => ex.message,:status => 422
  end

  def _create_for_forked_list
    committer = DataListCommitter.new(@data_list)
    data_item = committer.create_item(params[:kind], params[:title], params[:value])
    render :json => data_item.to_hash
  rescue Exception => ex
    render :text => ex.message,:status => 422
  end

  def update
    if @data_item.data_list.forked_from.blank?
      _update_for_origin_list
    else
      _update_for_forked_list
    end
  end

  def _update_for_origin_list
    @data_item.update_by_params(params[:title], params[:value])
    render :json => @data_item.to_hash
  rescue Exception => ex
    render :text => ex.message,:status => 422
  end

  def _update_for_forked_list
    committer = DataListCommitter.new(@data_item.data_list)
    committer.update_item(@data_item, params[:title], params[:value])
    render :json => @data_item.to_hash
  rescue Exception => ex
    render :text => ex.message,:status => 422
  end

  def destroy
    if @data_item.data_list.forked_from.blank?
      _destroy_for_origin_list
    else
      _destroy_for_forked_list
    end
  end

  def _destroy_for_origin_list
    data_list = @data_item.data_list
    @data_item.destroy
    render :json => {
      :data_list => {
        :server_updated_time => data_list.updated_at.to_i
      }
    }
  end

  def _destroy_for_forked_list
    data_list = @data_item.data_list
    committer = DataListCommitter.new(data_list)
    committer.remove_item(@data_item)
    render :json => {
      :data_list => {
        :server_updated_time => data_list.updated_at.to_i
      }
    }
  end

  def order
    if @data_item.data_list.forked_from.blank?
      _order_for_origin_list
    else
      _order_for_forked_list
    end
  end

  def _order_for_origin_list
    @data_item.insert_at(params[:left_position], params[:right_position])
    data_list = @data_item.data_list
    data_list.reload
    json = {
      :new_position => @data_item.position,
      :data_list => {
        :server_updated_time => data_list.updated_at.to_i
      }
    }
    render :json => json
  rescue DataItem::UnKnownPositionError => ex
    render :text=>"没有找到 position 是 #{params[:left_position]} 或 #{params[:right_position]} 的 data_item",:status => 404
  end

  def _order_for_forked_list
    data_list = @data_item.data_list
    committer = DataListCommitter.new(data_list)
    committer.insert_item(@data_item, params[:left_position], params[:right_position])
    data_list.reload
    json = {
      :new_position => @data_item.position,
      :data_list => {
        :server_updated_time => data_list.updated_at.to_i
      }
    }
    render :json => json
  rescue DataItem::UnKnownPositionError => ex
    render :text=>"没有找到 position 是 #{params[:left_position]} 或 #{params[:right_position]} 的 data_item",:status => 404
  end

end
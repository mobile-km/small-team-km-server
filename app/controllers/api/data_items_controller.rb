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
      :data_items => @data_list.data_items.map{|data_item|data_item.to_hash}
    }
    @data_list.read(current_user)
    render :json => json
  end

  def create
    data_item = @data_list.create_item(params[:kind], params[:title], params[:value])
    render :json => data_item.to_hash
  rescue Exception => ex
    render :text => ex.message,:status => 422
  end

  def update
    @data_item.update_by_params(params[:title], params[:value])
    render :json => @data_item.to_hash
  rescue Exception => ex
    render :text => ex.message,:status => 422
  end

  def destroy
    data_list = @data_item.data_list
    @data_item.destroy
    render :json => {
      :data_list => {
        :server_updated_time => data_list.updated_at.to_i
      }
    }
  end

  def order
    data_list = @data_item.data_list
    insert_at = data_list.data_items.find(params[:insert_at]).position
    @data_item.insert_at(insert_at)
    data_list.reload
    data_items = data_list.data_items.where("position >= #{@data_item.position}")
    json = {
      :order => data_items.map{|item|{:id => item.id, :position => item.position}},
      :data_list => {
        :server_updated_time => data_list.updated_at.to_i
      }
    }
    render :json => json
  rescue ActiveRecord::RecordNotFound => ex
    render :text=>"没有找到 ID 是 #{params[:insert_at]} 的 data_item",:status => 404
  end
end
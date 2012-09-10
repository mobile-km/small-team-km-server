class Api::DataItemsController < ApplicationController
  before_filter :login_required
  def per_load
    @data_item = DataItem.find(params[:id]) if params[:id]
    @data_list = DataList.find(params[:data_list_id]) if params[:data_list_id]
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
    @data_item.destroy
    render :status => 200
  end
end
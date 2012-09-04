class Api::AttitudesController < ApplicationController
  before_filter :login_required

  def push
    chat_node = ChatNode.find(params[:chat_node_id])
    attitude = chat_node.attitudes.find_or_create_by_user_id_and_kind(current_user.id,params[:kind])
    if attitude.valid?
      render :json=>{:status=>200}
    else
      render :json=>{:status=>422},:status=>422
    end
  end

  def pull
    attitudes = current_user.recevied_attitudes.
      where("attitudes.updated_at > ?",Time.at(params[:last_syn_attitudes_updated_time].to_i)).
      order("attitudes.updated_at asc")
    render :json=>attitudes.map{|attitude|attitude.to_hash}
  end
end
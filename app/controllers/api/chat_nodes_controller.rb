class Api::ChatNodesController < ApplicationController
  before_filter :login_required
  def create
    chat = Chat.find(params[:chat_id])
    chat_node = chat.chat_nodes.build(params[:chat_node])
    chat_node.sender = current_user
    if chat_node.save
      render :json=>{
        :uuid=>chat_node.uuid,
        :server_chat_node_id=>chat_node.id,
        :server_created_time=>chat_node.created_at.to_i
      }
    else
      render :status=>411,:text=>"411"
    end
  end

  def pull
    chat_nodes = current_user.recevied_chat_nodes.where("chat_nodes.updated_at > ?",Time.at(params[:last_syn_chat_node_created_time].to_i)).order("chat_nodes.updated_at asc")
    render(:json=>chat_nodes.map{|chat_node|chat_node.to_hash})
  end
end
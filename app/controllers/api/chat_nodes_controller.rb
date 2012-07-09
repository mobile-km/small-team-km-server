class Api::ChatNodesController < ApplicationController
  before_filter :login_required
  def create
    chat = Chat.find(params[:chat_id])
    chat_node = chat.chat_nodes.build(params[:chat_node])
    if chat_node.save
      render :json=>{
        :server_chat_node_id=>chat_node.id,
        :server_created_time=>chat_node.created_at.to_i
      }
    else
      render :status=>411,:text=>"411"
    end
  end
end
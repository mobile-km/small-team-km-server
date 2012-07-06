class Api::ChatsController < ApplicationController
  before_filter :login_required
  def create
    ids = params[:member_ids].split(",")
    chat = Chat.new(:chat_member_ids=>ids)
    if chat.save
      render :json=>{
        :server_chat_id=>chat.id,
        :server_created_time=>chat.created_at.to_i,
        :server_updated_time=>chat.updated_at.to_i
      }
    else
      render :status=>411,:text=>"411"
    end
  end

  def pull_chats_and_chat_nodes
    chats = current_user.joined_chats.where("updated_at > ?",Time.at(params[:last_syn_chat_updated_time].to_i))
    chat_nodes = current_user.send_chat_nodes.where("updated_at > ?",Time.at(params[:last_syn_chat_node_created_time].to_i))
    res = {
      :chats=>chats.map{|chat|chat.to_hash},
      :chat_nodes=>chat_nodes.map{|chat_node|chat_node.to_hash}
    }
    render :json=>res
  end
end
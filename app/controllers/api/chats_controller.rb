class Api::ChatsController < ApplicationController
  before_filter :login_required
  def create
    ids = params[:member_ids].split(",")
    ids << current_user.id
    ids.uniq!
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

  def pull
    chats = current_user.joined_chats.where("chats.updated_at > ?",Time.at(params[:last_syn_chat_updated_time].to_i))
    render(:json=>chats.map{|chat|chat.to_hash})
  end
end
class ContactsController < ApplicationController
  before_filter :login_required

  def invite
    user = User.find(params[:user_id])
    contact = current_user.invite(user,params[:message])
    render :json=>contact.to_hash
  end

  def accept_invite
    user = User.find(params[:user_id])
    contact = current_user.accept_invite(user)
    render :json=>contact.to_hash
  end

  def refuse_invite
    user = User.find(params[:user_id])
    current_user.refuse_invite(user)
    render :json=>{
      :status=>200
    }
  end

  def remove
    user = User.find(params[:user_id])
    current_user.remove_contact_user(user)
    render :json=>{
      :status=>200
    }
  end

  def refresh_status
    timestamp = params[:syn_contact_timestamp].to_i
    contacts = current_user.contacts.where("updated_at > ?",Time.at(timestamp))
    res = contacts.map{|contact|contact.to_hash}
    render :json=>res
  end

end
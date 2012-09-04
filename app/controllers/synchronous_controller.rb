class SynchronousController < ApplicationController
  def detail_meta
    time = Time.now.to_i
    last_syn_server_meta_updated_time = params[:last_syn_server_meta_updated_time].to_i
    notes = current_user.notes.where("notes.updated_at > ?",Time.at(last_syn_server_meta_updated_time))
    res = notes.map{|note|{:uuid=>note.uuid,:server_updated_time=>note.updated_at.to_i}}
    render :json=>{
      :last_syn_server_meta_updated_time=>time,
      :notes=>res
    }
  end

  def push
    note = Note.find_by_uuid(params[:note][:uuid])
    if note.blank?
      note = Note.new(params[:note])
      note.creator = current_user
      note.save
      p "push create note #{note.uuid}"
    else
      note.update_attributes(params[:note])
      p "push update note #{note.uuid}"
    end
    render :text=>note.updated_at.to_i
  end

  def push_image
    note = Note.find_by_uuid(params[:uuid])
    if note.kind == Note::Kind::IMAGE
      note.attachment = params[:image]
      note.save
    end
    p "push_image note #{note.uuid}"
    render :text=>"success"
  end

  def pull
    note = Note.find_by_uuid(params[:uuid])
    res = {
      :uuid=>note.uuid,
      :content=>note.content,
      :kind=>note.kind,
      :is_removed=>note.is_removed ? 1:0,
      :updated_at=>note.updated_at.to_i,
      :attachment_url=>note.attachment.url,
      :current_server_time=>Time.now.to_i
    }
    render :json=>res
  end
end
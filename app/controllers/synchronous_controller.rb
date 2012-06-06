class SynchronousController < ApplicationController
  def handshake
    uuid = UUIDTools::UUID.random_create.to_s
    count = current_user.notes.count
    render :json=>{:syn_task_uuid=>uuid,:note_count=>count}
  end

  # note.updated_at.to_i 秒数
  def compare
    note_uuid = params[:note_uuid]
    syn_task_uuid = params[:syn_task_uuid]
    client_note_updated_at = params[:updated_at].to_i
    result_hash = Note.compare(syn_task_uuid,note_uuid,client_note_updated_at)
    p "compare note_uuid #{note_uuid}"
    p "compare #{result_hash}"
    render :json=>result_hash
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

  def get_next
    syn_taks_uuid = params[:syn_taks_uuid]
    res = SynRecord.get_next(syn_taks_uuid,current_user)
    render :json=>res
  end
end
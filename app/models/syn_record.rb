class SynRecord < ActiveRecord::Base
  belongs_to :note, :primary_key=>"uuid"

  def self.get_next(syn_task_uuid,current_user)
    syn_records = SynRecord.find_all_by_syn_task_uuid(syn_task_uuid)
    syned_uuids = syn_records.map{|x| x.note_uuid}
    server_note_uuids = Note.find_all_by_creator_id(current_user.id).map{|x| x.uuid}

    new_server_note_uuids = server_note_uuids - syned_uuids

    if new_server_note_uuids.blank?
      syn_records.each{|syn|syn.destroy}
      return {:action=>"syn_completed"} 
    end

    next_uuid = new_server_note_uuids.first
    next_note = Note.find_by_uuid(next_uuid)

    SynRecord.create(:syn_task_uuid=>syn_task_uuid,:note_uuid=>next_note.uuid)
    return {
      :action=>"syn_has_next",
        :note=>{
          :uuid=>next_note.uuid,
          :content=>next_note.content,
          :kind=>next_note.kind,
          :is_removed=>next_note.is_removed ? 1:0,
          :updated_at=>next_note.updated_at.to_i,
          :attachment_url=>next_note.attachment.url
        }
      }
  end
end

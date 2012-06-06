class Note < ActiveRecord::Base
  class Kind
    TEXT = "TEXT";
    IMAGE = "IMAGE";
  end

  belongs_to :creator, :class_name=>"User"

  has_attached_file :attachment,
    :path => '/:class/:attachment/:id/:style/:basename.:extension',
    :url  => "http://storage.aliyun.com/#{OssManager::CONFIG["bucket"]}/:class/:attachment/:id/:style/:basename.:extension",
    :storage => :oss

  def self.compare(syn_task_uuid,note_uuid,client_note_updated_at)
    SynRecord.create(:syn_task_uuid=>syn_task_uuid,:note_uuid=>note_uuid)

    note = Note.find_by_uuid(note_uuid)
    return {:action=>"do_push"} if note.blank?

    server_note_updated_at = note.updated_at.to_i
    p "~~~~~~~~~~~~~~~~~~~"
    p "client_note_updated_at  #{client_note_updated_at}"
    p "server_note_updated_at  #{server_note_updated_at}"
    p "~~~~~~~~~~~~~~~~~~~"

    if client_note_updated_at == server_note_updated_at
      return {:action=>"do_nothing"}
    end

    if client_note_updated_at > server_note_updated_at
      return {:action=>"do_push"}
    end

    if client_note_updated_at < server_note_updated_at
      return {
        :action=>"do_pull",
        :note=>{
          :uuid=>note.uuid,
          :content=>note.content,
          :kind=>note.kind,
          :is_removed=>note.is_removed ? 1:0,
          :updated_at=>note.updated_at.to_i,
          :attachment_url=>note.attachment.url
        }
      }
    end
  end

  module UserMethods
    def self.included(base)
      base.has_many :notes,:foreign_key=>:creator_id
    end
  end
end

class FileEntity < ActiveRecord::Base
  FILE_ENTITY_ATTACHED_PATH     = "/MINDPIN_MRS_DATA:url"
  FILE_ENTITY_ATTACHED_URL      = "/attachments/:attachment/:id/:style/:filename"

  has_attached_file :attach,
                    :styles => {:large => '460x340#', :small => '220x140#'},
                    :path => FILE_ENTITY_ATTACHED_PATH,
                    :url  => FILE_ENTITY_ATTACHED_URL
end

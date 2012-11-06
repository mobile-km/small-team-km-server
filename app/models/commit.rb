class Commit < ActiveRecord::Base
  OPERATION_CREATE = 'CREATE'
  OPERATION_UPDATE = 'UPDATE'
  OPERATION_REMOVE = 'REMOVE'
  OPERATION_ORDER = 'ORDER'

  belongs_to :forked_data_list, :class_name => "DataList"
  belongs_to :file_entity

  def origin_item
    self.forked_data_list.forked_from.data_items.find_by_seed(self.seed)
  end

  def ready?
    self.forked_data_list.commits[0] == self
  end

  def conflict?
    self.operation != OPERATION_CREATE && self.origin_item.blank?
  end

  def to_hash
    {
      :operation => self.operation,
      :title      => self.title,
      :kind       => self.kind,
      :content    => self.content,
      :url        => self.url,
      :seed       => self.seed,
      :image_url  => self.file_entity.blank? ? "" : self.file_entity.attach.url,
      :conflict   => self.conflict?,
      :position   => self.position
    }
  end
end

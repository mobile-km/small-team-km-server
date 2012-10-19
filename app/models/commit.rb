class Commit < ActiveRecord::Base
  OPERATION_CREATE = 'CREATE'
  OPERATION_UPDATE = 'UPDATE'
  OPERATION_REMOVE = 'REMOVE'

  belongs_to :forked_data_list, :class_name => "DataList"

  def origin_item
    self.forked_data_list.forked_from.data_items.find_by_seed(self.seed)
  end
end

class DataListReadings < ActiveRecord::Base
  belongs_to :user
  belongs_to :data_list_id
end

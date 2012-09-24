class Watch < ActiveRecord::Base
  belongs_to :user
  belongs_to :data_list

  module UserMethods
    def self.included(base)
      base.has_many :watchs
      base.has_many :watched_list, :through => :watchs, :source => :data_list
    end

    def watch(data_list)
      self.watchs.find_or_create_by_data_list_id(data_list.id)
    end

    def unwatch(data_list)
      watch = self.watchs.find_by_data_list_id(data_list.id)
      watch.destroy if !watch.blank?
    end
  end
end

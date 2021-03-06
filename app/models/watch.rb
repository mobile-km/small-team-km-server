class Watch < ActiveRecord::Base
  belongs_to :user
  belongs_to :data_list

  after_save :set_data_list_delta_flag
  after_destroy :set_data_list_delta_flag
  def set_data_list_delta_flag
    if !data_list.blank?
      data_list.delta = true
      data_list.save
    end
  end

  def data_list_hash
    if data_list.blank?
      return { :id => data_list_id, :is_removed => true }
    end
    data_list.to_hash
  end

  module UserMethods
    def self.included(base)
      base.has_many :watchs
      base.has_many :watched_list, :through => :watchs, :source => :data_list
    end

    def watch(data_list)
      self.watchs.find_or_create_by_data_list_id(data_list.id)
    end

    def unwatch(data_list_id)
      watch = self.watchs.find_by_data_list_id(data_list_id)
      watch.destroy if !watch.blank?
    end

    def watched?(data_list)
      self.watched_list.include?(data_list)
    end
  end
end

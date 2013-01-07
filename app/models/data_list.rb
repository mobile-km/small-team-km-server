# -*- coding: utf-8 -*-
class DataList < ActiveRecord::Base
  class RepeatForkError<Exception;end

  KIND_COLLECTION = 'COLLECTION'
  KIND_STEP       = 'STEP'
  KINDS = [ KIND_COLLECTION, KIND_STEP ]

  has_many :data_items, :order => "position"
  belongs_to :creator, :class_name => 'User'
  has_many :data_list_readings

  has_many :watchs
  has_many :watch_users, :through => :watchs, :source => :user

  belongs_to :forked_from, :class_name => 'DataList'
  has_many :forks, :class_name => 'DataList', :foreign_key => :forked_from_id
  has_many :commits, :foreign_key => :forked_data_list_id, :order => "commits.created_at asc"

  validates :title, :presence => true
  validates :kind,  :presence => true, :inclusion => DataList::KINDS

  scope :with_kind_collection, where(:kind => KIND_COLLECTION).order('updated_at DESC')
  scope :with_kind_step, where(:kind => KIND_STEP).order('updated_at DESC')
  scope :public_timeline, where(:public => true).order('updated_at DESC')
  scope :with_be_forked, joins('inner join data_lists as data_lists_other on data_lists_other.forked_from_id = data_lists.id').group('data_lists.id')

  def to_hash(neste_count = 0)
    if neste_count >= 3
      forked_from = {}
      forked_from_id = nil
    else
      forked_from = self.forked_from.blank? ? {} : self.forked_from.to_hash(neste_count+1)
      forked_from_id = self.forked_from_id
    end

    return {
      :id         => self.id,
      :title      => self.title,
      :kind       => self.kind,
      :public     => self.public?.to_s,
      :has_commits => self.has_commits?.to_s,
      :forked_from_id => forked_from_id,
      :forked_from => forked_from,
      :forked_from_is_removed => self.forked_from_is_removed?.to_s,
      :is_removed => false,
      :creator => {
        :id => self.creator.id,
        :name => self.creator.name,
        :avatar_url => self.creator.logo.url,
        :server_created_time => self.creator.created_at.to_i,
        :server_updated_time => self.creator.updated_at.to_i
      },
      :server_created_time => self.created_at.to_i,
      :server_updated_time => self.updated_at.to_i
    }
  end

  # 创建列表项
  def create_item(kind, title, value)
    item = case kind
    when DataItem::KIND_TEXT
      self.data_items.create(:kind => DataItem::KIND_TEXT, :title => title, :content => value)
    when DataItem::KIND_IMAGE
      file_entity = (value.class == FileEntity) ? value : FileEntity.new(:attach => value)
      self.data_items.create(:kind => DataItem::KIND_IMAGE, :title => title, :file_entity => file_entity)
    when DataItem::KIND_URL
      self.data_items.create(:kind => DataItem::KIND_URL, :title => title, :url => value)
    when DataItem::KIND_MUSIC
      self.data_items.create(:kind => DataItem::KIND_MUSIC, :title => title, :music_info_id => value.id)
    when DataItem::KIND_PRODUCT
      self.data_items.create(:kind => DataItem::KIND_PRODUCT, :title => title, :product_id => value)
    end

    if !item.valid?
      raise DataItem::TitleRepeatError if item.errors.first[0] == :title && !item.title.blank?

      raise DataItem::UrlRepeatError if item.errors.first[0] == :url && !item.url.blank?
    end
    item
  end

  def read(user)
    self.data_list_readings.find_or_create_by_user_id(user.id)
  end

  def read?(user)
    !self.data_list_readings.find_by_user_id(user.id).blank?
  end

  def has_commits?
    #!self.forks.map{|data_list|data_list.commits}.flatten.blank?
    !Commit.find_by_sql(%`
      select commits.* from commits
        inner join data_lists as forked_data_lists on commits.forked_data_list_id = forked_data_lists.id
        inner join data_lists as origin_data_lists on origin_data_lists.id = forked_data_lists.forked_from_id
      where 
        origin_data_lists.id = #{self.id}
    `).blank?
  end

  def forked_from_is_removed?
    !self.forked_from_id.blank? && self.forked_from.blank?
  end

  def commit_users
    User.find_by_sql(%`
      select users.* from users
        inner join data_lists on data_lists.creator_id = users.id
        inner join commits on commits.forked_data_list_id = data_lists.id 
      where
        data_lists.forked_from_id = #{self.id}
    `).uniq
  end

  def get_commits_of(user)
    Commit.find_by_sql(%`
      select commits.* from commits
        inner join data_lists as forked_data_lists on commits.forked_data_list_id = forked_data_lists.id
        inner join data_lists as origin_data_lists on origin_data_lists.id = forked_data_lists.forked_from_id
      where 
        origin_data_lists.id = #{self.id}
          and
        forked_data_lists.creator_id = #{user.id}
      order by commits.created_at asc
    `
    )
  end

  def commit_meta_hash
    commit_users.map do |user|
      {
        :committer => {
          :id => user.id,
          :name => user.name,
          :avatar_url => user.logo.url,
          :server_created_time => user.created_at.to_i,
          :server_updated_time => user.updated_at.to_i
        },
        :count => get_commits_of(user).length
      }
    end
  end

  module UserMethods
    def self.included(base)
      base.has_many :data_lists,
                    :foreign_key => :creator_id

      base.has_many :forked_data_lists,
                    :class_name => "DataList",
                    :conditions => "data_lists.forked_from_id is not null",
                    :foreign_key => :creator_id

      base.send :include, InstanceMethods
      base.after_create :create_example_data_lists
    end

    module InstanceMethods
      def create_example_data_lists
        hash = YAML.load_file Rails.root.join('config/example_data_lists.yml')
        new_data_list_hash = {}
        hash.each do |kind,list|
          list.each do |title,items|

            data_list = self.data_lists.create(
              :title => title,
              :kind => kind,
              :public => false
            )
            new_data_list_hash[kind] = data_list
            items.each do |item|
              data_list.create_item(DataItem::KIND_TEXT, item['title'], item['content'])
            end
          end
        end

        dl = new_data_list_hash[DataList::KIND_STEP]
        DataList.where(:id=>dl.id).update_all(:updated_at=>(Time.now+1))
      end

      def fork(data_list)
        if !self.data_lists.find_by_forked_from_id(data_list.id).blank?
          raise DataList::RepeatForkError.new
        end
        # 创建对应的 data_list
        forked_data_list = self.data_lists.create(
          :title => data_list.title,
          :kind => data_list.kind,
          :public => false,
          :forked_from => data_list
        )
        # 创建对应的 data_item
        data_list.data_items.each do |data_item|
          seed = data_item.get_or_create_seed

          item = case data_item.kind
          when DataItem::KIND_TEXT
            forked_data_list.create_item(data_item.kind,data_item.title,data_item.content)
          when DataItem::KIND_IMAGE
            forked_data_list.create_item(data_item.kind,data_item.title,data_item.file_entity)
          when DataItem::KIND_URL
            forked_data_list.create_item(data_item.kind,data_item.title,data_item.url)
          end
          item.update_attribute(:seed, seed)
        end
        forked_data_list
      end

      def forked?(data_list)
        !self.data_lists.where(:forked_from_id => data_list.id).blank?
      end
    end
  end

  define_index do
    indexes title, :sortable => true
    indexes data_items(:title)
    indexes data_items(:content)

    has creator_id
    has public
    has watchs(:user_id), :as => :watch_user_ids
    set_property :delta => true
  end
end

class Contact < ActiveRecord::Base
  class Status
    INVITED = "INVITED"
    BE_INVITED = "BE_INVITED"
    BE_REFUSED = "BE_REFUSED"
    APPLIED = "APPLIED"
    BE_REMOVED = "BE_REMOVED"
  end
  class ContactStatus
    SELF = "SELF"
    APPLIED = "APPLIED"
    INVITED = "INVITED"
    BE_INVITED = "BE_INVITED"
    REFUSED = "REFUSED"
    BE_REFUSED = "BE_REFUSED"
    REMOVED = "REMOVED"
    BE_REMOVED = "BE_REMOVED"
    NOTHING = "NOTHING"
  end

  belongs_to :contact_user, :class_name=>"User"
  belongs_to :user

  def to_hash
    {
      :contact_user_info=>{
        :user_id=>self.contact_user.id,
        :user_name=>self.contact_user.name,
        :user_avatar_url=>self.contact_user.logo.url,
        :contact_status=>self.user.contact_status?(self.contact_user)
      },
      :status=>self.status,
      :message=>self.message,
      :server_created_time=>self.created_at.to_i,
      :server_updated_time=>self.updated_at.to_i
    }
  end

  module UserMethods
    def self.included(base)
      base.has_many :contacts
      base.has_many :contact_users, :through=>:contacts, 
        :conditions=>"contacts.status = '#{Status::APPLIED}'"
      base.has_many :invited_users, :through=>:contacts, :source=>:contact_user,
        :conditions=>"contacts.status = '#{Status::INVITED}'"
      base.has_many :be_invited_users, :through=>:contacts, :source=>:contact_user,
        :conditions=>"contacts.status = '#{Status::BE_INVITED}'"
      base.has_many :be_refused_users, :through=>:contacts, :source=>:contact_user,
        :conditions=>"contacts.status = '#{Status::BE_REFUSED}'"
      base.has_many :be_removed_users, :through=>:contacts, :source=>:contact_user,
        :conditions=>"contacts.status = '#{Status::BE_REMOVED}'"
    end

    # 是否互为联系人
    def is_contact_user?(contact_user)
      contact_users.include?(contact_user)
    end

    # 我是否邀请了 contact_user
    def is_invited?(contact_user)
      invited_users.include?(contact_user)
    end

    # contact_user是否邀请了我
    def is_be_invited?(contact_user)
      be_invited_users.include?(contact_user)
    end

    # 我是否拒绝了 contact_user 的邀请
    def is_refused?(contact_user)
      contact_user.is_be_refused?(self)
    end

    # contact_user 是否拒绝了我的邀请
    def is_be_refused?(contact_user)
      be_refused_users.include?(contact_user)
    end

    # 我是否删除了 contact_user 这个联系人
    def is_removed?(contact_user)
      contact_user.is_be_removed?(self)
    end

    # contact_user 是否删除了我这个联系人
    def is_be_removed?(contact_user)
      be_removed_users.include?(contact_user)
    end

    def contact_status?(contact_user)
      return ContactStatus::SELF if contact_user == self
      return ContactStatus::APPLIED if is_contact_user?(contact_user)
      return ContactStatus::INVITED if is_invited?(contact_user)
      return ContactStatus::BE_INVITED if is_be_invited?(contact_user)
      return ContactStatus::REFUSED if is_refused?(contact_user)
      return ContactStatus::BE_REFUSED if is_be_refused?(contact_user)
      return ContactStatus::REMOVED if is_removed?(contact_user)
      return ContactStatus::BE_REMOVED if is_be_removed?(contact_user)
      ContactStatus::NOTHING
    end

    # 发送邀请
    def invite(contact_user,message)
      return if is_contact_user?(contact_user) || is_be_invited?(contact_user)

      contact = self.contacts.find_by_contact_user_id(contact_user.id)
      if contact.blank?
        contact = self.contacts.create(:contact_user=>contact_user,:message=>message,:status=>Status::INVITED)
      else
        contact.update_attributes(:message=>message,:status=>Status::INVITED)
      end

      other_contact = contact_user.contacts.find_by_contact_user_id(self.id)
      if other_contact.blank?
        contact_user.contacts.create(:contact_user=>self,:message=>message,:status=>Status::BE_INVITED)
      else
        other_contact.update_attributes(:message=>message,:status=>Status::BE_INVITED)
      end
      contact
    end

    # 接受邀请
    def accept_invite(user)
      return if !self.is_be_invited?(user)

      contact = self.contacts.find_by_contact_user_id(user.id)
      contact.update_attributes(:status=>Status::APPLIED)

      other_contact = user.contacts.find_by_contact_user_id(self.id)
      other_contact.update_attributes(:status=>Status::APPLIED)
      contact
    end

    # 拒绝邀请
    def refuse_invite(user)
      return if !self.is_be_invited?(user)

      contact = self.contacts.find_by_contact_user_id(user.id)
      contact.destroy

      other_contact = user.contacts.find_by_contact_user_id(self.id)
      other_contact.update_attributes(:status=>Status::BE_REFUSED)
    end

    def remove_contact_user(contact_user)
      return if !self.is_contact_user?(contact_user)

      contact = self.contacts.find_by_contact_user_id(user.id)
      contact.destroy

      other_contact = user.contacts.find_by_contact_user_id(self.id)
      other_contact.update_attributes(:status=>Status::BE_REMOVED)
    end

  end
end

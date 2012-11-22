class VersionChangeLog < ActiveRecord::Base
  STATUS_NEWEST = 'NEWEST'
  STATUS_UPDATE = 'UPDATE'
  STATUS_EXPIRED = 'EXPIRED'

  validates :version, :usable_oldest_version, :change_log, :presence => true
  def self.check_version(version)
    version_change_log = VersionChangeLog.last

    newest_version = version_change_log.version
    usable_oldest_version = version_change_log.usable_oldest_version
    change_log = version_change_log.change_log

    raise 'version 参数错误' if version > newest_version
  
    if version == newest_version
      status = STATUS_NEWEST
    elsif version < newest_version && version >= usable_oldest_version
      status = STATUS_UPDATE
    else
      status = STATUS_EXPIRED
    end

    return {
      :status => status,
      :newest_version_change_log => {
        :version => newest_version,
        :change_log => change_log
      }
    }
  end
end

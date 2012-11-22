class AddVersionChangeLog121122 < ActiveRecord::Migration
  def change
    VersionChangeLog.create(
      :version => '0.52',
      :usable_oldest_version => '0.01',
      :change_log => %`Teamkn 0.52 版本主要更新：

1 新用户增加范例列表
2 增加新手指南`
    )
  end
end

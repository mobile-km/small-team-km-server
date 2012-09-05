require 'spec_helper'

describe '数据列表' do
  let(:ben7th) {FactoryGirl.create :user}
  let(:lifei) {FactoryGirl.create :user, :with_data_lists}

  describe '个人动作' do
    it '用户可以创建一个列表' do
      DataList.count.should == 0

      ben7th.data_lists.count.should == 0
      ben7th.data_lists.create :title => '我的列表',
                               :kind => 'COLLECTION'
      ben7th.data_lists.count.should == 1

      DataList.count.should == 1
      DataList.last.creator.should == ben7th
    end

    it '可以分别查询用户的两种不同类型的列表' do

      lifei.data_lists.count.should_not == 0

      count_collection = lifei.data_lists.with_kind_collection.count
      count_step = lifei.data_lists.with_kind_step.count

      count_collection.should_not == 0
      count_collection.should_not == 0

      lifei.data_lists.create :title => '我的列表',
                              :kind => 'COLLECTION'

      lifei.data_lists.with_kind_collection.count.should == count_collection + 1
    end
  end
end
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

    describe '用户可以在列表中创建列表项' do
      it '用户可以创建 URL 类型的列表项' do
        data_list = lifei.data_lists.last
        
        data_list.create_item('URL', 'ben7th的微博', 'http://weibo.com/ben7th')
        data_list.create_item('URL', '负伤的骑士的微博', 'http://weibo.com/fushang318')

        data_list.data_items.count.should == 2
      end

      it '用户可以创建 IMAGE 类型的列表项' do
        data_list = lifei.data_lists.last

        image1 = File.new File.join(Rails.root, 'spec/factories/test.png')
        image2 = File.new File.join(Rails.root, 'spec/factories/test.png')

        data_list.create_item('IMAGE', '图一', image1)
        data_list.create_item('IMAGE', '图二', image1)
        data_list.data_items.count.should == 2
      end

      it '用户可以创建 TEXT 类型的列表项' do
        data_list = lifei.data_lists.last

        data_list.create_item('TEXT', 'haha', '哈哈哈哈哈')
        data_list.create_item('TEXT', 'hehe', '呵呵呵呵嘿')
        data_list.data_items.count.should == 2
      end

      it '列表项标题不能重复' do
        data_list = lifei.data_lists.last

        data_list.create_item('IMAGE', 'haha', '哈哈哈哈哈')
        data_list.data_items.count.should == 1

        expect {
          data_list.create_item('IMAGE', 'haha', '呵呵呵呵嘿')
        }.to raise_error(DataItem::TitleRepeatError)
        data_list.data_items.count.should == 1
      end

      it '列表项URL不能重复' do
        data_list = lifei.data_lists.last

        data_list.create_item('URL', 'ben7th的微博', 'http://weibo.com/ben7th')
        data_list.data_items.count.should == 1

        expect {
          data_list.create_item('URL', '负伤的骑士的微博', 'http://weibo.com/ben7th')
        }.to raise_error(DataItem::UrlRepeatError)
        data_list.data_items.count.should == 1
      end
    end

  end
end
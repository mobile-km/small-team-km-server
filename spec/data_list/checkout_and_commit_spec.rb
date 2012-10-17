require 'spec_helper'

describe '数据列表的多人编辑' do
  let(:ben7th) {FactoryGirl.create :user, :with_data_lists}
  let(:lifei) {FactoryGirl.create :user, :with_data_lists}

  it '可以签出(checkout)他人的列表' do
  	data_list_0 = ben7th.data_lists[0]
    data_list_1 = ben7th.data_lists[1]

    lifei.checkout data_list_0
    lifei.checkout data_list_1

    lifei.checkout_data_lists.include?(data_list_0).should == true
    lifei.checkout_data_lists.include?(data_list_1).should == true
    lifei.checkout_data_lists.include?(ben7th.data_lists[2]).should == false
  end

  it '可以编辑已经签出的列表' do
    data_list_0 = ben7th.data_lists[0]
    data_list_1 = ben7th.data_lists[1]

    lifei.checkout data_list_0
    lifei.checkout data_list_1

    commiter = DataListCommiter.new :user => lifei,
                                    :data_list => data_list_0

    # 编辑·增加项
    commiter.create_item('URL', 'ben7th的微博', 'http://weibo.com/ben7th')
    commiter.create_item('URL', '负伤的骑士的微博', 'http://weibo.com/fushang318')
    commiter.commit

    # 编辑·删除项
    commiter.remove_item data_list_0.data_items.first
    commiter.commit

    # 编辑·修改项
    commiter.update_item data_list_0.data_items.first, 'URL', 'google首页', 'http://google.com'
    commiter.commit

    commiter.commits.count.should == 3
    commiter.not_pushed_commits.count.should == 3

    # 向原作者提交修改
    commiter.push_request

    expect {
      # 尝试修改没有签出的他人的 data_list 抛异常
      DataListCommiter.new :user => lifei,
                           :data_list => ben7th.data_lists[2]
    }.to raise_error(DataListCommiter::NotCheckoutError)
  end
end
require 'spec_helper'

describe '数据列表的多人编辑' do
  let(:ben7th) {FactoryGirl.create :user, :with_data_lists}
  let(:lifei)  {FactoryGirl.create :user, :with_data_lists}
  let(:wudi)   {FactoryGirl.create :user, :with_data_lists}

  it '可以签出(checkout)他人的列表' do
  	data_list_0 = ben7th.data_lists[0]
    data_list_1 = ben7th.data_lists[1]

    lifei.fork data_list_0
    lifei.fork data_list_1

    lifei.forked_data_lists.include?(data_list_0).should == true
    lifei.forked_data_lists.include?(data_list_1).should == true
    lifei.forked_data_lists.include?(ben7th.data_lists[2]).should == false

    fork_0 = lifei.data_lists[-2]
    fork_1 = lifei.data_lists[-1]

    fork_0.forked_from.should == data_list_0
    fork_1.forked_from.should == data_list_1

    data_list_0.forks.length.should == 1
    data_list_0.forks[0].should == fork_0

    wudi.fork data_list_0
    data_list_0.forks.length.should == 2
    data_list_0.forks.include?(fork_0).should == true
    data_list_0.forks.include?(wudi.data_lists[-1]).should == true
  end

  it '可以编辑已经签出的列表' do
    data_list_0 = ben7th.data_lists[0]
    data_list_1 = ben7th.data_lists[1]

    lifei.fork data_list_0
    lifei.fork data_list_1

    forked_list = lifei.data_lists.last
    commiter = DataListCommiter.new(forked_list)

    # 如果尝试针对一个原始的（非fork而来）data_list构建DataListCommiter
    # 则抛出异常
    expect {
      DataListCommiter.new(lifei.data_lists.first)
    }.to raise_error(DataListCommiter::NotForkDataListError)


    # 编辑·增加项
    commiter.create_item('URL', 'ben7th的微博', 'http://weibo.com/ben7th')
    commiter.create_item('URL', '负伤的骑士的微博', 'http://weibo.com/fushang318')
    commiter.commits.length.should == 2

    # 编辑·删除项
    commiter.remove_item forked_list.data_items.first

    # 编辑·修改项
    commiter.update_item forked_list.data_items.first, 'URL', 'google首页', 'http://google.com'

    commiter.commits.length.should == 4
  end

  it '原列表作者可以获取所有针对该列表的来自不同用户的commits' do
    data_list_0 = ben7th.data_lists[0]

    lifei.fork data_list_0
    forked_list_lifei = lifei.data_lists.last
    commiter_lifei = DataListCommiter.new(forked_list_lifei)

    wudi.fork data_list_0
    forked_list_wudi = wudi.data_lists.last
    commiter_wudi = DataListCommiter.new(forked_list_wudi)

    data_list_0.has_commits?.should == false # 虽然被fork，但没有被任何人修改过

    commiter_lifei.create_item('URL', 'ben7th的微博', 'http://weibo.com/ben7th')
    commiter_lifei.create_item('URL', '负伤的骑士的微博', 'http://weibo.com/fushang318')
    commiter_lifei.remove_item forked_list_lifei.data_items[0]
    commiter_lifei.update_item forked_list_lifei.data_items[1], 'URL', 'google首页', 'http://google.com'

    commiter_wudi.create_item('URL', '百度贴吧', 'http://tieba.baidu.com')
    commiter_wudi.remove_item forked_list_wudi.data_items[2]
    commiter_wudi.update_item forked_list_wudi.data_items[1], 'URL', '苹果', 'http://apple.com'

    data_list_0.has_commits?.should == true

    data_list_0.commit_users.length == 2
    data_list_0.commit_users.include?(lifei).should == true
    data_list_0.commit_users.include?(wudi).should == true

    # 获取每个编辑者的修改
    # 获取到的是 DataListCommit 对象的数组
    lifei_commits = data_list_0.get_commits_of(lifei)
    lifei_commits.length.should == 4

    wudi_commits = data_list_0.get_commits_of(wudi)
    lifei_commits.length.should == 3

    # DataListCommit 对象的行为
    # 增
    lifei_commit_0 = lifei_commits[0]
    lifei_commit_0.operation.should == :CREATE
    lifei_commit_0.kind.should == DataItem::KIND_URL
    lifei_commit_0.title.should == 'ben7th的微博'
    lifei_commit_0.content.should == 'http://weibo.com/ben7th'

    # 删
    lifei_commit_2 = lifei_commits[2]
    lifei_commit_2.operation.should == :REMOVE
    lifei_commit_2.item.should == forked_list_lifei.data_items[0]

    # 改
    lifei_commit_3 = lifei_commits[3]
    lifei_commit_2.operation.should == :UPDATE
    lifei_commit_2.item.should == forked_list_lifei.data_items[1]
    lifei_commit_0.kind.should == DataItem::KIND_URL
    lifei_commit_0.title.should == 'google首页'
    lifei_commit_0.content.should == 'http://google.com'
  end

  it '用户可以逐项接受或拒绝其他编辑者对于自己列表的修改' do
    data_list_0 = ben7th.data_lists[0]
    lifei.fork data_list_0
    forked_list_lifei = lifei.data_lists.last
    commiter_lifei = DataListCommiter.new(forked_list_lifei)
    commiter_lifei.create_item('URL', 'ben7th的微博', 'http://weibo.com/ben7th')
    commiter_lifei.create_item('URL', '负伤的骑士的微博', 'http://weibo.com/fushang318')
    commiter_lifei.remove_item forked_list_lifei.data_items[0]
    commiter_lifei.update_item forked_list_lifei.data_items[1], 'URL', 'google首页', 'http://google.com'
    commiter_lifei.updata_item forked_list_lifei.data_items.last 'URL', '负伤の骑士の微博', 'http://weibo.com/fushang318'

    lifei_commits = data_list_0.get_commits_of(lifei)
    lifei_commits[0].ready?.should == true # 这一项修改已经可以被处理
    lifei_commits[1].ready?.should == false # 前面的修改还未处理，这一项还没有准备好被处理
    lifei_commits[2].ready?.should == false
    lifei_commits[3].ready?.should == false
    lifei_commits[4].ready?.should == false

    # ben7th接受第一项修改
    data_list_0.next_commit.should == lifei_commits[0]
    data_list_0.accept_next_commit
    lifei_commits[1].ready?.should == true
    lifei_commits[1].conflict?.should == false
    lifei_commits[2].ready?.should == false
    lifei_commits[3].ready?.should == false
    lifei_commits[4].ready?.should == false

    # ben7th拒绝第二项修改
    data_list_0.next_commit.should == lifei_commits[1]
    data_list_0.reject_next_commit
    lifei_commits[2].ready?.should == true
    lifei_commits[2].conflict?.should == false
    lifei_commits[3].ready?.should == false
    lifei_commits[4].ready?.should == false

    data_list_0.accept_next_commit # 2
    data_list_0.accept_next_commit # 3

    lifei_commits[4].ready?.should == true
    lifei_commits[4].conflict?.should == true 
    # 以seed来判断，当该操作针对的 data_item 在 forked_from的data_list里
    # 找不到对应的 seed 相同的 data_item 时，就算该操作冲突
    # 此时UI上的处理是忽略之，直接继续跳到 data_list_0.accept_next_commit

    expect {
      data_list_0.accept_next_commit
    }.to raise_error(DataListCommiter::CanNotAcceptconflictCommitError)

    # conflict 的 commit 只能拒绝，不能接受
    data_list_0.reject_next_commit

    data_list_0.next_commit.should == nil


    # 所有导致 conflict 的情况，其实只有一种
    # 当修改者新增了某一项，但是原作者没有接受这一项的新增时
    # 以后所有针对这一项的修改都算作 conflict
  end

  it '以seed值来表示data_item的同一来源' do
    data_list_0 = ben7th.data_lists[0]
    lifei.fork data_list_0
    forked_list_lifei = lifei.data_lists.last
    commiter_lifei = DataListCommiter.new(forked_list_lifei)
    commiter_lifei.create_item('URL', 'ben7th的微博', 'http://weibo.com/ben7th')
    commiter_lifei.create_item('URL', '负伤的骑士的微博', 'http://weibo.com/fushang318')
    commiter_lifei.remove_item forked_list_lifei.data_items[0]
    commiter_lifei.update_item forked_list_lifei.data_items[1], 'URL', 'google首页', 'http://google.com'
    commiter_lifei.updata_item forked_list_lifei.data_items.last 'URL', '负伤の骑士の微博', 'http://weibo.com/fushang318'

    data_list_0.data_items[0].seed.should == forked_list_lifei.data_items[0].seed
    data_list_0.data_items[1].seed.should == forked_list_lifei.data_items[1].seed
    data_list_0.data_items[2].seed.should == forked_list_lifei.data_items[2].seed

    # ben7th接受了第一项修改，创建出了新的 data_item
    data_list_0.accept_next_commit
    data_list_0.data_items[-1].seed.should == forked_list_lifei.data_items[-2].seed
  end
end
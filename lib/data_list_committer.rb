class DataListCommitter
  class NotForkDataListError<Exception;end

  def initialize(forked_list)
    raise NotForkDataListError if forked_list.forked_from.blank?
    @forked_list = forked_list
  end

  def create_item(kind, title, value)
    # 创建 data_item
    item = @forked_list.create_item(kind, title, value)
    item.get_or_create_seed
    # 创建 commit
    @forked_list.commits.create(
      :operation => Commit::OPERATION_CREATE,
      :seed => item.seed, 
      :title => item.title, 
      :content => item.content,
      :url => item.url,
      :file_entity_id => item.file_entity_id,
      :kind => item.kind
    )
  end

  def update_item(data_item, title, value)
    raise '参数 data_item 不是 forked_list 的条目' if !@forked_list.data_items.include?(data_item)

    seed = data_item.seed
    data_item.update_by_params(title, value)
    # 创建 commit
    @forked_list.commits.create(
      :operation => Commit::OPERATION_UPDATE,
      :seed => seed, 
      :title => data_item.title, 
      :content => data_item.content,
      :url => data_item.url,
      :file_entity_id => data_item.file_entity_id,
      :kind => data_item.kind
    )
  end

  def remove_item(data_item)
    raise '参数 data_item 不是 forked_list 的条目' if !@forked_list.data_items.reload.include?(data_item)

    seed = data_item.seed
    # 删除data_item
    data_item.destroy
    # 创建 commit
    @forked_list.commits.create(:operation => Commit::OPERATION_REMOVE, :seed => seed)
  end

  def commits
    @forked_list.commits
  end
end
class DataListMerger
  class NotForkDataListError<Exception;end
  class CanNotAcceptconflictCommitError<Exception;end

  attr_reader :forked_data_list, :forked_from
  def initialize(forked_data_list)
    raise NotForkDataListError if forked_data_list.forked_from.blank?
    @forked_data_list = forked_data_list
    @forked_from = @forked_data_list.forked_from
  end

  def editor
    @forked_data_list.creator
  end

  def get_commits
    @forked_data_list.commits
  end

  def next_commit
    @forked_data_list.commits.first
  end

  def accept_next_commit
    commit = next_commit
    raise CanNotAcceptconflictCommitError.new if commit.conflict?

    data_item = case commit.operation
    when Commit::OPERATION_CREATE
      _accept_next_commit__create
    when Commit::OPERATION_UPDATE
      _accept_next_commit__update
    when Commit::OPERATION_REMOVE
      _accept_next_commit__remove
    when Commit::OPERATION_ORDER
      _accept_next_commit__order
    end
    @forked_data_list.reload
    data_item
  end

  def reject_next_commit
    next_commit.destroy
    @forked_data_list.reload
  end

  def accept_commits
    forked_from.data_items.each{|data_item|data_item.destroy}

    forked_data_list.data_items.each do |data_item|
      seed = data_item.get_or_create_seed

      item = case data_item.kind
      when DataItem::KIND_TEXT
        forked_from.create_item(data_item.kind,data_item.title,data_item.content)
      when DataItem::KIND_IMAGE
        forked_from.create_item(data_item.kind,data_item.title,data_item.file_entity)
      when DataItem::KIND_URL
        forked_from.create_item(data_item.kind,data_item.title,data_item.url)
      end
      item.update_attribute(:seed, seed)
    end
    forked_data_list.commits.each{|commit|commit.destroy}
  end

  def reject_commits
    forked_data_list.commits.each{|commit|commit.destroy}
  end

  def accept_rest_commits
    @forked_data_list.commits.each do |commit|
      if commit.conflict?
        commit.destroy
        next
      end

      case commit.operation
      when Commit::OPERATION_CREATE
        _accept_next_commit__create
      when Commit::OPERATION_UPDATE
        _accept_next_commit__update
      when Commit::OPERATION_REMOVE
        _accept_next_commit__remove
      when Commit::OPERATION_ORDER
        _accept_next_commit__order
      end

    end
  end

  def reject_rest_commits
    reject_commits
  end

  def _accept_next_commit__create
    commit = next_commit

    value = case commit.kind
      when DataItem::KIND_TEXT
        commit.content
      when DataItem::KIND_IMAGE
        commit.file_entity
      when DataItem::KIND_URL
        commit.url
    end
    item = @forked_from.create_item(commit.kind, commit.title, value)
    item.update_attribute(:seed, commit.seed)

    commit.destroy
    item
  end

  def _accept_next_commit__update
    commit = next_commit

    value = case commit.kind
      when DataItem::KIND_TEXT
        commit.content
      when DataItem::KIND_IMAGE
        commit.file_entity
      when DataItem::KIND_URL
        commit.url
    end
    commit.origin_item.update_by_params(commit.title, value)

    commit.destroy
    commit.origin_item
  end

  def _accept_next_commit__remove
    commit = next_commit

    data_item = commit.origin_item
    data_item.destroy

    commit.destroy
    data_item
  end

  def _accept_next_commit__order
    commit = next_commit

    data_item = commit.origin_item

    position_data_item = @forked_from.data_items.find_by_position(commit.position)
    if position_data_item.blank?
      data_item.position = commit.position
      data_item.save
    elsif position_data_item != data_item
      data_items = @forked_from.data_items
      index = data_items.index(position_data_item)
      right_data_item = data_items[index+1]
      right_position = right_data_item.blank? ? nil : right_data_item.position
      data_item.insert_at(commit.position, right_position)
    end
    commit.destroy
    data_item
  end

end
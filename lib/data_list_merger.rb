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

    case commit.operation
    when Commit::OPERATION_CREATE
      _accept_next_commit__create
    when Commit::OPERATION_UPDATE
      _accept_next_commit__update
    when Commit::OPERATION_REMOVE
      _accept_next_commit__remove
    end
    @forked_data_list.reload
  end

  def reject_next_commit
    next_commit.destroy
    @forked_data_list.reload
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
  end

  def _accept_next_commit__remove
    commit = next_commit

    data_item = forked_from.data_items.find_by_seed(commit.seed)
    data_item.destroy

    commit.destroy
  end

end
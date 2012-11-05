ActiveRecord::Base.transaction do 
  data_lists = DataList.all
  data_list_count = data_lists.count

  data_lists.each_with_index do |data_list, index|
    p "处理 data_list #{index+1}/#{data_list_count}"

    old_data_items = data_list.data_items
    next if old_data_items.blank?
    first_item = old_data_items.shift
    first_item.position = SortChar.g(nil, nil)
    first_item.save
    new_data_items = [first_item]

    while !old_data_items.blank?
      item = old_data_items.shift
      item.position = SortChar.g(new_data_items.last.position, nil)
      item.save
      new_data_items.push item
    end
  end
  p "success"
end
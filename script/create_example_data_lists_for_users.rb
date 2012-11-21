ActiveRecord::Base.transaction do
  users = User.all
  count = users.count

  users.each_with_index do |user, index|
    p "处理 user #{index+1}/#{count}"
    user.create_example_data_lists
  end

  p "success"
end
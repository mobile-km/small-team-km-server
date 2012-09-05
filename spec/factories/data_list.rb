FactoryGirl.define do
  factory :data_list do
    sequence(:title)  {|n| "title#{n}"}
    sequence(:kind) {|n| "COLLECTION"}
  end
end
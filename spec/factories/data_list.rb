FactoryGirl.define do
  factory :data_list do
    sequence(:title)  {|n| "title#{n}"}
    sequence(:kind) {|n| "COLLECTION"}
    sequence(:public) {|n| true}
  end

  trait :with_data_items do
    after_create do |data_list|
      16.times do
        Timecop.travel(Time.now + 1.hours)
        data_list.create_item('TEXT', rand.to_s, rand.to_s)
      end
    end
  end

end
FactoryGirl.define do
  factory :user, :aliases => [:creator] do
    sequence(:name)  {|n| "fake#{n}"}
    sequence(:email) {|n| "fake#{n}@fake.fake"}
    password 'fake'

    trait :with_data_lists do
      after_create do |user|
        16.times do
          Timecop.travel(Time.now + 1.hours)
          FactoryGirl.create(:data_list, :kind => 'COLLECTION', :creator_id => user.id)
        end
        16.times do
          Timecop.travel(Time.now + 1.hours)
          FactoryGirl.create(:data_list, :kind => 'STEP', :creator_id => user.id)
        end
      end
    end

    trait :with_data_lists_and_items do
      after_create do |user|
        16.times do
          Timecop.travel(Time.now + 1.hours)
          FactoryGirl.create(:data_list, :with_data_items, :kind => 'COLLECTION', :creator_id => user.id)
        end
      end
    end
  end
end
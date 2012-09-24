FactoryGirl.define do
  factory :user, :aliases => [:creator] do
    sequence(:name)  {|n| "fake#{n}"}
    sequence(:email) {|n| "fake#{n}@fake.fake"}
    password 'fake'

    trait :with_data_lists do
      after_create do |user|
        16.times do
          Timecop.travel(Time.now + 1.hours)
          user.data_lists << FactoryGirl.create(:data_list, :kind => 'COLLECTION')
        end
        16.times do
          Timecop.travel(Time.now + 1.hours)
          user.data_lists << FactoryGirl.create(:data_list, :kind => 'STEP')
        end
      end
    end

  end
end
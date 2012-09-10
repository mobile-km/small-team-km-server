FactoryGirl.define do
  factory :file_entity do
    sequence(:attach)  {|n| File.new File.join(Rails.root, 'spec/factories/test.png') }
  end
end
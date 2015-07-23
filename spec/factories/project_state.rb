FactoryGirl.define do

  factory :project_state do
    symbol 'active'
    display_name 'Active'
  
    trait :active do
      symbol 'active'
      display_name 'Active'
    end

    trait :freezed do
      symbol 'freezed'
      display_name 'Freezed'
    end

    trait :completed do
      symbol 'completed'
      display_name 'Completed'
    end
  end
end

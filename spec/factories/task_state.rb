FactoryGirl.define do

  factory :task_state do
    symbol 'pending'
    display_name 'Pending'

    trait :completed do
      symbol 'completed'
      display_name 'Completed'
    end

    trait :pending do
      symbol 'pending'
      display_name 'Pending'
    end

    trait :waiting_for do
      symbol 'waiting_for'
      display_name 'Waiting for'
    end

    trait :work_in_progress do
      symbol 'work_in_progress'
      display_name 'Work in progress'
    end
  end
end

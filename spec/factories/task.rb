FactoryGirl.define do

  factory :task do
    description "Task description"
    association :task_state, :factory => [:task_state, :pending]
  end

  trait :have_to do
    have_to true
  end

  trait :to_be_done_today do
    date Date.today
  end

  trait :to_be_done_tomorrow do
    date Date.tomorrow
  end

  trait :to_be_done_next_week do
    date 7.days.from_now.to_date
  end

  trait :someday_maybe do
    have_to false
  end

  trait :done_today do
    completed_at Time.now
    association :task_state, :factory => [:task_state, :completed]
  end

  trait :completed do
    completed_at Time.now
    association :task_state, :factory => [:task_state, :completed]
  end
end

FactoryGirl.define do

  factory :project do
    name "Project name"
    association :project_state, factory: :project_state

    trait :active do
      association :project_state, :factory => [:project_state, :active]
    end

    trait :freezed do
      association :project_state, :factory => [:project_state, :freezed]
    end

    trait :completed do
      completed_at Date.today
      association :project_state, :factory => [:project_state, :completed]
    end
  end
end

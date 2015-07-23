FactoryGirl.define do

  factory :note do
    title "Note title"
    body "Note body"
  end

  trait :without_title do
    title nil
    body "Note body"
  end
  
  trait :with_old_title do
    title "Old title"
  end
end

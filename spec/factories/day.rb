FactoryGirl.define do
  factory :day do
    date Date.today
    tasks []
  end

  trait :today do
    date Date.today
  end

  trait :recent do
    date Date.strptime("2015-05-01")
  end
end

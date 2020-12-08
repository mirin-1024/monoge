FactoryBot.define do
  factory :micropost do
    content { "MyText" }
    created_at { Time.zone.now }
    association :user
  end

  trait :yesterday do
    content { "Yesterday" }
    created_at { 1.day.ago }
  end

  trait :day_before_yesterday do
    content { "Day before yesterday" }
    created_at { 2.days.ago }
  end

  trait :now do
    content { "Now" }
    created_at { Time.zone.now }
  end
end

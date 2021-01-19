FactoryBot.define do
  factory :post do
    content { 'MyText' }
    created_at { Time.zone.now }
    association :user
  end

  factory :test_post, class: 'Post' do
    content { Faker::Lorem.sentence(word_count: 5) }
    created_at { Time.zone.now }
    association :user
  end

  trait :yesterday do
    content { 'Yesterday' }
    created_at { 1.day.ago }
  end

  trait :day_before_yesterday do
    content { 'Day before yesterday' }
    created_at { 2.days.ago }
  end

  trait :now do
    content { 'Now' }
    created_at { Time.zone.now }
  end
end

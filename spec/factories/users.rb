FactoryBot.define do
  factory :user, traits: %i[password non_admin activated] do
    name { 'Foo Bar' }
    email { 'foobar@example.com' }
  end

  factory :invalid_user, class: 'User', traits: %i[non_admin activated] do
    name { 'Invalid User' }
    email { "#{'a' * 39}@example.com" }
    password { 'password' }
    password_confirmation { 'passward' }
  end

  factory :test_user, class: 'User', traits: %i[password non_admin activated] do
    name { Faker::Name.name }
    email { Faker::Internet.email }
  end

  factory :admin_user, class: 'User', traits: %i[password admin activated] do
    name { 'Admin User' }
    email { 'adminuser@example.com' }
  end

  # trait
  trait :password do
    password { 'password' }
    password_confirmation { 'password' }
  end

  trait :admin do
    admin { true }
  end

  trait :non_admin do
    admin { false }
  end

  trait :activated do
    activated { true }
    activated_at { Time.zone.now }
  end

  trait :non_activated do
    activated { false }
    activated_at { nil }
  end

  # personal trait
  trait :guest do
    name { 'Guest User' }
    email { 'guest@example.com' }
  end
end

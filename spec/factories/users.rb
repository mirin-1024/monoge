FactoryBot.define do
  factory :user do
    name { "Foo Bar" }
    email { "foobar@example.com" }
    password { "password" }
    password_confirmation { "password" }
    activated { true }
    activated_at { Time.zone.now }
  end

  factory :invalid_user, class: 'User' do
    name { "Invalid User" }
    email { "a" * 39 + "@example.com" }
    password { "password" }
    password_confirmation { "passward" }
    activated { true }
    activated_at { Time.zone.now }
  end

  factory :other_user, class: 'User' do
    name { "Foobar1" }
    email { "foobar1@example.com" }
    password { "password" }
    password_confirmation { "password" }
    activated { true }
    activated_at { Time.zone.now }
  end

  factory :test_user, class: 'User' do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { "password" }
    password_confirmation { "password" }
    activated { true }
    activated_at { Time.zone.now }
  end

  factory :admin_user, class: 'User' do
    name { "Admin User" }
    email { "adminuser@example.com" }
    password { "password" }
    password_confirmation { "password" }
    admin { true }
    activated { true }
    activated_at { Time.zone.now }
  end

  trait :activated do
    activated { true }
    activated_at { Time.zone.now }
  end

  trait :non_activated do
    activated { false }
    activated_at { nil }
  end
end

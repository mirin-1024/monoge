FactoryBot.define do
  factory :user, traits: %i[non_admin activated] do
    name { 'Foo Bar' }
    email { 'foobar@example.com' }
    password { 'password' }
    password_confirmation { 'password' }
  end

  factory :invalid_user, class: 'User', traits: %i[non_admin activated] do
    name { 'Invalid User' }
    email { "#{'a' * 39}@example.com" }
    password { 'password' }
    password_confirmation { 'passward' }
  end

  # 削除
  factory :other_user, class: 'User', traits: %i[non_admin activated] do
    name { 'Foobar1' }
    email { 'foobar1@example.com' }
    password { 'password' }
    password_confirmation { 'password' }
  end

  factory :test_user, class: 'User', traits: %i[non_admin activated] do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
  end

  factory :admin_user, class: 'User', traits: %i[admin activated] do
    name { 'Admin User' }
    email { 'adminuser@example.com' }
    password { 'password' }
    password_confirmation { 'password' }
  end

  factory :guest_user, class: 'User', traits: %i[non_admin activated] do
    name { 'Guest User' }
    email { 'guest@example.com' }
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
end

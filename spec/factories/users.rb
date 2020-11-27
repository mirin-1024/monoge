FactoryBot.define do
  factory :user do
    name { "Foobar" }
    email { "foobar@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end

  factory :invuser, class: User do
    name { "invalid user" }
    email { "a" * 39 + "@example.com" }
    password { "password" }
    password_confirmation { "passwor" }
  end

  factory :other_user, class: User do
    name { "Foobar1" }
    email { "foobar1@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end

  factory :test_user, class: User do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { "password" }
    password_confirmation { "password" }
  end

  trait :admin do
    admin { true }
  end
end

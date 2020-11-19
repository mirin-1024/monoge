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
end

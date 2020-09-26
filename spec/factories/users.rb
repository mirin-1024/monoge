FactoryBot.define do
  factory :user do
    name { "Foobar" }
    email { "foobar@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end

FactoryBot.define do
  factory :list do
    label { 'Label' }
    content { 'List Content' }
    association :user
  end
end

FactoryBot.define do
  factory :company do
    sequence(:name) { |n| "New Company ##{n}" }
  end
end

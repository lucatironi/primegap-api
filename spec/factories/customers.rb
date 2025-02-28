FactoryBot.define do
  factory :customer do
    sequence(:full_name) { |n| "first_name_#{n} last_name_#{n}" }
    sequence(:first_name) { |n| "first_name_#{n}" }
    sequence(:last_name) { |n| "last_name_#{n}" }
    sequence(:phone) { |n| "021234567#{n}" }
    sequence(:email) { |n| "customer#{n}@example.com" }
  end
end

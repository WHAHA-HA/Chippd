FactoryGirl.define do
  factory :customer do
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    sequence(:email) { |n| "customer-#{n}@gmail.com" }
    password "123abc123"
    password_confirmation "123abc123"
  end
end

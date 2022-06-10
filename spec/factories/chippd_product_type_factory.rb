FactoryGirl.define do
  factory :chippd_product_type do
    sequence(:name) { |n| "#{Faker::Name.name} #{n}" }
    short_description Faker::Lorem.sentence
  end
end
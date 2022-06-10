FactoryGirl.define do
  factory :product_collection do
    name Faker::Name.name
    filter_text Faker::Name.name
    long_description Faker::Name.name
  end
end
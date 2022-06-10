FactoryGirl.define do
  factory :content do
    name Faker::Name.name
    body Faker::Lorem.paragraphs.join("\n\n")
  end
end
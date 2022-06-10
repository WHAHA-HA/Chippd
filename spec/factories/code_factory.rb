FactoryGirl.define do
  factory :code do
    sequence(:value) { |n| "code#{n}" }
  end
end
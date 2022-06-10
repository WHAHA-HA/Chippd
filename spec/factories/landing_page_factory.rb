FactoryGirl.define do
  factory :landing_page do
    sequence(:title) { |n| "Landing Page #{n}" }
    sequence(:permalink) { |n| "landing-page-#{n}" }
    use_case_url 'http://google.com'
    tagline Faker::Lorem.sentence
    call_to_action Faker::Lorem.sentence
    next_step_text 'Buy Now'
    next_step_url 'http://google.com'
    meta_title 'Landing Page Title'
    meta_description 'This is a Landing Page.'
    meta_keywords 'landing, page, keywords'

    factory :landing_page_with_images_and_steps do
      ignore do
        images_count 3
        steps_count 3
      end

      after_create do |landing_page, evaluator|
        FactoryGirl.create_list(:landing_page_image, evaluator.images_count, :landing_page => landing_page)
        FactoryGirl.create_list(:landing_page_step, evaluator.steps_count, :landing_page => landing_page)
      end
    end
  end

  factory :landing_page_image do
    image File.new(File.join(Rails.root, 'spec/factories/assets/image.jpg'))
    caption Faker::Lorem.sentence
  end

  factory :landing_page_step do
    image File.new(File.join(Rails.root, 'spec/factories/assets/image.jpg'))
    title Faker::Lorem.sentence
    description Faker::Lorem.sentence
  end
end
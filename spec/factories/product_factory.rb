FactoryGirl.define do
  factory :product do
    sequence(:name) { |n| "#{Faker::Name.name} #{n}" }
    description Faker::Lorem.paragraphs.join("\n\n")
    association :product_collection
    price '55.00'

    after_build do |product|
      product.chippd_product_types << FactoryGirl.create(:chippd_product_type)
      product.chippd_product_types << FactoryGirl.create(:chippd_product_type)
    end

    factory :product_with_images do
      ignore do
        images_count 3
      end

      after_create do |product, evaluator|
        FactoryGirl.create_list(:product_image, evaluator.images_count, :product => product)
      end
    end

    factory :product_with_details do
      ignore do
        details_count 3
      end

      after_create do |product, evaluator|
        FactoryGirl.create_list(:product_detail, evaluator.details_count, :product => product)
      end
    end

    factory :product_with_images_and_details do
      ignore do
        images_count 3
        details_count 3
      end

      after_create do |product, evaluator|
        FactoryGirl.create_list(:product_image, evaluator.images_count, :product => product)
        FactoryGirl.create_list(:product_detail, evaluator.details_count, :product => product)
      end
    end
  end

  factory :product_image do
    image File.new(File.join(Rails.root, 'spec/factories/assets/image.jpg'))
    caption Faker::Lorem.sentence
  end

  factory :product_detail do
    sequence(:name) { |n| "#{Faker::Name.name} #{n}" }

    ignore do
      options_count 3
    end

    after_create do |product_detail, evaluator|
      FactoryGirl.create_list(:detail_option, evaluator.options_count, :product_detail => product_detail)
    end
  end

  factory :detail_option do
    sequence(:name) { |n| "#{Faker::Name.name} #{n}" }
  end
end
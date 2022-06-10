FactoryGirl.define do
  factory :order do
    factory :order_with_line_items do
      ignore do
        line_items_count 3
      end

      after_create do |order, evaluator|
        FactoryGirl.create_list(:line_item, evaluator.line_items_count, :order => order)
      end
    end
  end

  factory :line_item do
    chippd_product_type
    association :product, :factory => :product_with_images
  end
end

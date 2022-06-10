FactoryGirl.define do
  factory :page_line_item do
  end

  factory :page do
    page_template
    chippd_product_type
    customer

    factory :page_with_memberships do
      ignore do
        memberships_count 3
      end

      after_create do |page, evaluator|
        FactoryGirl.create_list(:membership, evaluator.memberships_count, :page => page)
      end
    end
  end
end
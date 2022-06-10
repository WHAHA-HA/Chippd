FactoryGirl.define do
  factory :page_template do
    sequence(:name) { |n| "Page Template #{n}" }

    factory :page_template_with_widgets do
      ignore do
        widgets_count 3
      end

      after_create do |page_template, evaluator|
        FactoryGirl.create_list(:page_template_widget, evaluator.widgets_count, :page_template => page_template)
      end
    end
  end

  factory :page_template_widget do
    name 'Text'
    type :text
    limit 1
  end
end


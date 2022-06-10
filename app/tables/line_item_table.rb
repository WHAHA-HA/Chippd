class LineItemTable < TableCloth::Base
  column :product_name
  column :quantity
  column :purchased_at do |object, view|
    object.purchased_at.stamp(configatron.datetime_formats.default)
  end
  column :codes do |object, view|
    object.codes.collect { |c| view.content_tag(:code, c) }.join(", ").html_safe
  end

  actions do
    action {|object, view| view.link_to('Customer', view.admin_customer_path(object.page.customer_id), :class => 'btn') }
  end
end
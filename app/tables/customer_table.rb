class CustomerTable < AdminTable
  column :first_name
  column :last_name
  column :email do |object, view|
    view.mail_to(object.email, object.email)
  end
  column :confirmed? do |object, view|
    object.confirmed? ? "yes" : view.link_to("confirm", confirm_admin_customer_path(object), :remote => true, :id => "confirm_#{object.id}", :class => "btn")
  end
  column :customer_since do |object|
    object.created_at.stamp(configatron.date_formats.long)
  end
  column :last_sign_in do |object|
    (object.last_sign_in_at.present? ? object.last_sign_in_at.stamp(configatron.datetime_formats.default) : '')
  end

  actions do
    action {|object, view| view.link_to("View", admin_customer_path(object), :class => "btn") }
  end
end

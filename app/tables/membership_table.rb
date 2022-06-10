class MembershipTable < TableCloth::Base
  column :name do |object, view|
    object.customer.full_name
  end
  column :key do |object, view|
    view.content_tag(:code, object.key)
  end
  column :privacy
  column :access do |object, view|
    view.content_tag(:code, object.access)
  end
  column :last_viewed_at do |object, view|
    object.last_viewed_at.stamp(configatron.datetime_formats.default)
  end
  column :created_at do |object, view|
    object.created_at.stamp(configatron.datetime_formats.default)
  end
end
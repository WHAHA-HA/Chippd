class ContactRequestTable < AdminTable
  column :from do |object|
    object.email
  end
  column :topic
  column :received_on do |object|
    object.created_at.stamp(configatron.datetime_formats.default)
  end

  actions do
    action {|object, view| view.link_to('View', resource_path(object), :class => 'btn') }
    action {|object, view| view.link_to_destroy(object) }
  end
end
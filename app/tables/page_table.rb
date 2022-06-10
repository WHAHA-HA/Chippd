class PageTable < AdminTable
  column :name
  column :customer do |object, view|
    view.link_to(object.customer, admin_customer_path(object.customer))
  end
  column :b2b, :label => 'B2B Enabled?' do |object, view|
    view.content_tag(:i, "", :class => 'icon-ok') if object.b2b_enabled?
  end
  column :page_template, :label => "Template"
  column :product_collection, :label => "Collection"
  column :chippd_product_type, :label => "Privacy"
  column :updated_at do |object, view|
    object.updated_at.stamp(configatron.datetime_formats.default)
  end

  actions do
    action {|object, view| view.link_to_edit(object) }
  end
end


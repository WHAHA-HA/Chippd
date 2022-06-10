class PageTemplateWidgetTable < AdminTable
  column :icon do |object, view|
    view.image_tag("my_chippd/icon-#{object.type}.png", :class => "thumbnail", :width => 50, :style => 'background-color: #6c4b78')
  end
  column :name do |object|
    object.name
  end
  column :limit do |object, view|
    object.limit.present? ? object.limit : '&#8734;'.html_safe
  end

  actions do
    action {|object, view| view.link_to_edit(object) }
    action {|object, view| view.link_to_destroy(object) }
  end
end


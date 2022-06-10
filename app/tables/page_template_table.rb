class PageTemplateTable < AdminTable
  column :name

  column :variation do |object, view|
    content_tag(:code, object.variation)
  end

  column :widgets do |object, view|
    view.link_to_collection(object.widgets.length, view.admin_page_template_page_template_widgets_path(object))
  end

  actions do
    action {|object, view| view.link_to_edit(object) }
    action {|object, view| view.link_to_destroy(object) }
  end
end


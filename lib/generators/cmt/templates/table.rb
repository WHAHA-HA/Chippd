class <%= class_name %>Table < AdminTable
  column :<%= @model_attributes.first.name %>

  action {|object, view| view.link_to_toggle_visibility(object) }
  action {|object, view| view.link_to_edit(object) }
  action {|object, view| view.link_to_destroy(object) }
end


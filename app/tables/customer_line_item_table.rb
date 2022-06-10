class CustomerLineItemTable < LineItemTable
  actions do
    action {|object, view| view.link_to('View', view.edit_admin_order_path(object.order), :class => 'btn') if object.order }
  end
end
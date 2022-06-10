class ProductDetailTable < AdminTable
  column :name
  column :options do |object, view|
    view.link_to_collection(object.options.length, view.admin_product_detail_options_path(view.parent, object))
  end

  actions do
    action {|object, view| view.link_to_edit(object) }
    action {|object, view| view.link_to_destroy(object) }
  end
end
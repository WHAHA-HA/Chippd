class ProductTable < AdminTable
  column :image do |object, view|
    view.image_tag((object.default_image ? object.default_image.small.remote_url : 'http://quickimage.it/50&text=%3F'), :class => "thumbnail")
  end
  column :name
  column :price do |object, view|
    view.number_to_currency(object.price.to_s)
  end
  column :images do |object, view|
    view.link_to_collection(object.images.length, view.admin_product_images_path(object))
  end
  column :preorder, :label => "" do |object, view|
    object.preorder ? view.content_tag(:span, "preorder", :class => "label label-warning") : nil
  end
  column :sold_out, :label => "" do |object, view|
    object.sold_out ? view.content_tag(:span, "sold out", :class => "label label-warning") : nil
  end
end

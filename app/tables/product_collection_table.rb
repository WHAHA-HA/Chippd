class ProductCollectionTable < AdminTable
  column :image do |object, view|
    view.image_tag(object.image.remote_url, :class => "thumbnail", :width => 100)
  end
  column :name
  column :products do |object, view|
    view.link_to_collection(object.products.length, view.admin_product_collection_products_path(object))
  end
end


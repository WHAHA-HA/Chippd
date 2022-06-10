class ProductImageTable < AdminTable
  column :image do |object, view|
    view.image_tag(object.small.remote_url, :class => "thumbnail")
  end
  column :caption
end
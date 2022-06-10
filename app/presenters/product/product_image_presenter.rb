class ProductImagePresenter < BasePresenter
  presents :product_image
  delegate :caption, :to => :product_image

  def large_image
    image_tag(product_image.large.remote_url, :title => product_image.caption, :alt => product_image.caption)
  end

  def medium_image
    image_tag(product_image.medium.remote_url, :title => product_image.caption, :alt => product_image.caption)
  end

  def thumbnail_image
    image_tag(product_image.small.remote_url, :title => product_image.caption, :alt => product_image.caption)
  end
end

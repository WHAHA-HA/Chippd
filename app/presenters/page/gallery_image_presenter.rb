class GalleryImagePresenter < BasePresenter
  presents :gallery_image

  def link_to_image
    link_to(thumb.html_safe, gallery_image.image.remote_url)
  end

  def thumb
    image_tag(gallery_image.thumb.remote_url, :alt => "")
  end

  def sortable_content
    image_tag(gallery_image.thumb.remote_url, :alt => "photo", :width => 50)
  end
end
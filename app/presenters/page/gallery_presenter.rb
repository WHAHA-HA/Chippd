class GalleryPresenter < PageSectionPresenter

  def title
    handle_none(page_section.title) do
      content_tag(:h1, page_section.title)
    end
  end

  def images
    page_section.gallery_images.collect { |gallery_image| GalleryImagePresenter.new(gallery_image, @template) }
  end

  protected

  def sortable_content
    page_section.title? ? page_section.title : 'Gallery'
  end
end

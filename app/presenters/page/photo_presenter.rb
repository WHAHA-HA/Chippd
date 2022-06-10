class PhotoPresenter < PageSectionPresenter
  def caption
    handle_none(page_section.caption) do
      content_tag(:figcaption, page_section.caption)
    end
  end

  def image
    if page_section.url.blank?
      image_tag(page_section.image.remote_url, :alt => "photo")
    else
      link_to(image_tag(page_section.image.remote_url, :alt => "photo"), page_section.url)
    end
  end

  protected

  def sortable_content
    page_section.caption? ? page_section.caption : 'Photo'
  end
end

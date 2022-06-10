class EngagementPresenter < PageSectionPresenter

  def title
    handle_none(page_section.title) do
      content_tag(:h2, page_section.title)
    end
  end

  def images
    page_section.engagement_images.collect { |engagement_image| EngagementImagePresenter.new(engagement_image, @template) }
  end

  protected

  def sortable_content
    page_section.title? ? page_section.title : 'Engagement'
  end
end

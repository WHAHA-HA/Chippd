class TextPresenter < PageSectionPresenter

  def heading
    content_tag(:h1, page_section.heading)
  end

  def body
    markdown(page_section.body)
  end

  protected

  def sortable_content
    if page_section.heading.present?
      page_section.heading
    else
      page_section.body.truncate(40)
    end
  end
end
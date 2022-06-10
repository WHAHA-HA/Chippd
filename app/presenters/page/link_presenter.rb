class LinkPresenter < PageSectionPresenter
  def link_to_asset
    link_to(page_section.title, page_section.url, :class => page_section.kind)
  end

  protected

  def sortable_content
    page_section.title
  end
end
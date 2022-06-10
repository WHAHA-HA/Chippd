class GenericPdfPresenter < PageSectionPresenter
  def link_to_asset
    link_to(page_section.title, page_section.file.remote_url, 'data-impressions-behavior' => 'click')
  end

  protected

  def sortable_content
    page_section.title
  end
end
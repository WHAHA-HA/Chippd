class PdfPresenter < PageSectionPresenter
  def link_to_asset
    link_to(page_section.title, page_section.file.remote_url, :class => page_section.kind, 'data-impressions-behavior' => 'click')
  end

  protected

  def sortable_content
    page_section.title
  end
end
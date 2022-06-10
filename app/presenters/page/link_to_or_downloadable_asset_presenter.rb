class LinkToOrDownloadableAssetPresenter < PageSectionPresenter
  def url
    page_section.downloadable ? page_section.file.remote_url : page_section.url
  end

  def link_to_asset
    link_to("View my #{type.name.downcase}", url)
  end
end
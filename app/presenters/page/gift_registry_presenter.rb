class GiftRegistryPresenter < PageSectionPresenter
  def when_a_mail_to_address_exists
    yield if page_section.mail_to_address.present?
  end

  def mail_to_address
    markdown(page_section.mail_to_address)
  end

  def sources
    page_section.sources.collect { |source| GiftRegistrySourcePresenter.new(source, @template) }
  end
end

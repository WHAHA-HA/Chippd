class WeddingPartyPresenter < PageSectionPresenter

  def bridesmaid_images
    page_section.wedding_party_images.collect { |image| WeddingPartyImagePresenter.new(image, @template) if image.image_type == 'bridesmaid' }.compact
  end

  def groomsman_images
    page_section.wedding_party_images.collect { |image| WeddingPartyImagePresenter.new(image, @template) if image.image_type == 'groomsman' }.compact
  end

end

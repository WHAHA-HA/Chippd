class WeddingPartyImagePresenter < BasePresenter
  presents :wedding_party_image
  delegate :name, to: :wedding_party_image

  def title
    handle_none(wedding_party_image.title) do
      content_tag(:figcaption, wedding_party_image.title)
    end
  end

  def image
    image_tag(wedding_party_image.image.remote_url, :alt => wedding_party_image.name)
  end

end

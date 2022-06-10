class WeddingParty < PageSectionWithAttachments
  MINIMUM_NUMBER_OF_IMAGES = 1
  MAXIMUM_NUMBER_OF_IMAGES = 16
  embeds_many :wedding_party_images, :cascade_callbacks => true

  def storage_used
    wedding_party_images.sum(&:storage_used)
  end

  def wedding_party_images_json
    wedding_party_images.map do |image|
      {
        id: image.id,
        image_type: image.image_type,
        url: image.original.remote_url,
        name: image.name,
        title: image.title
      }
    end.to_json
  end

end

class BeforeBaby < PageSectionWithAttachments
  MINIMUM_NUMBER_OF_IMAGES = 1
  MAXIMUM_NUMBER_OF_IMAGES = 12
  embeds_many :baby_images, :cascade_callbacks => true

  def storage_used
    baby_images.sum(&:storage_used)
  end

  def baby_images_json
    baby_images.map do |image|
      {
        id: image.id,
        url: image.original.remote_url,
        caption: image.caption
      }
    end.to_json
  end
end

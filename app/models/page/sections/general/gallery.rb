class Gallery < PageSectionWithAttachments
  MINIMUM_NUMBER_OF_IMAGES = 1
  MAXIMUM_NUMBER_OF_IMAGES = 16
  embeds_many :gallery_images, :cascade_callbacks => true

  field :title, :type => String

  validates_presence_of :title

  def storage_used
    gallery_images.sum(&:storage_used)
  end

  def gallery_images_json
    gallery_images.map do |image|
      {
        id: image.id,
        url: image.thumb.url
      }
    end.to_json
  end
end

class Engagement < PageSectionWithAttachments
  MINIMUM_NUMBER_OF_IMAGES = 1
  MAXIMUM_NUMBER_OF_IMAGES = 16
  embeds_many :engagement_images, :cascade_callbacks => true

  field :title, :type => String

  validates_presence_of :title

  def storage_used
    engagement_images.sum(&:storage_used)
  end

  def engagement_images_json
    engagement_images.map do |image|
      {
        id: image.id,
        url: image.thumb.url
      }
    end.to_json
  end
end

class Photo < PageSectionWithAttachments
  field :caption, :type => String
  field :url, :type => String

  image_attachment_fields :original, :image

  image_accessor :original do
    copy_to(:image){|a| a.thumb('600x').process(:auto_orient) }
  end
  image_accessor :image

  validates_presence_of :caption
  validates :url, :format => {
    :with => URI::regexp(%w(http https)),
    :message => 'is an invalid URL',
    :allow_blank => true
  }

  # Note: we are intentionally not including the storage size
  # of image to avoid confusion over discrepancies between
  # the file uploaded and the reported space used in the UI.
  def storage_used
    calculate_storage_used_for(:original)
  end
end

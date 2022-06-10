class LinkToOrDownloadableAsset < PageSection
  include AttachmentField

  field :url, :type => String
  field :downloadable, :type => Boolean, :default => false

  attachment_fields :file
  image_accessor :file

  validates :url, :presence => {
    :unless => :downloadable
  }
  validates :file, :presence => {
    :if => :downloadable
  }

  def uses_storage?
    true
  end

  def storage_used
    calculate_storage_used_for(:file)
  end
end

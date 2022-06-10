class GalleryImage
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Orderable
  include AttachmentField

  embedded_in :gallery

  field :caption, :type => String

  image_attachment_fields :original, :image, :thumb

  image_accessor :original do
    copy_to(:image){|a| a.thumb('600x') }
    copy_to(:thumb){|a| a.thumb('150x150#') }
  end
  image_accessor :image
  image_accessor :thumb

  orderable

  default_scope order_by(:position.asc)

  # Note: we are intentionally not including the storage size
  # of image and thumb to avoid confusion over discrepancies
  # between the file uploaded and the reported space used in the UI.
  def storage_used
    calculate_storage_used_for(:original)
  end
end

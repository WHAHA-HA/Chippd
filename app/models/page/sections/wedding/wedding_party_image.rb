class WeddingPartyImage
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Orderable
  include AttachmentField

  embedded_in :wedding_party

  field :image_type, :type => String
  field :name,       :type => String
  field :title,      :type => String

  image_attachment_fields :original, :image

  image_accessor :original do
    copy_to(:image){|a| a.thumb('300x300#') }
  end
  image_accessor :image

  validates :name,  presence: true
  validates :title, presence: true

  orderable

  default_scope order_by(:position.asc)

  # Note: we are intentionally not including the storage size
  # of image to avoid confusion over discrepancies between
  # the file uploaded and the reported space used in the UI.
  def storage_used
    calculate_storage_used_for(:original)
  end
end

class PlaceToStay
  include Mongoid::Document
  include Mongoid::Timestamps
  include AttachmentField

  embedded_in :places_to_stay, :inverse_of => :featured_place
  embedded_in :places_to_stay, :inverse_of => :places

  field :name, :type => String
  field :address, :type => String
  field :city, :type => String
  field :state, :type => String
  field :postal_code, :type => String
  field :country, :type => String, :default => 'United States'
  field :phone, :type => String
  field :price, :type => Integer, :default => 1
  field :url, :type => String
  field :booking_info, :type => String

  image_attachment_fields :original, :image, :thumb

  image_accessor :original do
    copy_to(:image){|a| a.thumb('600x') }
    copy_to(:thumb){|a| a.thumb('150x150#') }
  end
  image_accessor :image
  image_accessor :thumb

  validates :name, :presence => true
  validates :price, :presence => true
  validates :url, :presence => true, :format => {
    :with => URI::regexp(%w(http https)),
    :message => 'is an invalid URL'
  }

  # Note: we are intentionally not including the storage size
  # of image and thumb to avoid confusion over discrepancies
  # between the file uploaded and the reported space used in the UI.
  def storage_used
    calculate_storage_used_for(:original)
  end
end

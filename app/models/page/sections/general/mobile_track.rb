class MobileTrack
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Orderable
  include AttachmentField

  embedded_in :mobile_playlist

  field :name,           :type => String
  field :artist_name,    :type => String
  field :job_id,         :type => String
  field :purchaseable,   :type => Boolean, :default => false
  field :downloadable,   :type => Boolean, :default => false
  field :price_in_cents, :type => Integer
  field :itunes_url,     :type => String
  field :amazon_url,     :type => String

  attachment_fields :original, :file
  image_accessor :file

  orderable

  default_scope order_by(:position.asc)

  set_callback(:save, :before) do |document|
    if document.file.present? && document.name.blank?
      document.name = File.basename(document.file_uid, '.*')
    end
  end

  def storage_used
    calculate_storage_used_for(:file)
  end
end

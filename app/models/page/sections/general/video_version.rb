class VideoVersion
  include Mongoid::Document
  include Mongoid::Timestamps
  include AttachmentField

  embedded_in :video
  embedded_in :babys_first
  embedded_in :timeline_asset
  embedded_in :auction

  field :preset, :type => String
  field :codec, :type => String
  attachment_field :file
  image_accessor :file

  def storage_used
    calculate_storage_used_for(:file)
  end
end

class Video < PageSectionWithAttachments
  embeds_many :versions, :class_name => "VideoVersion", :cascade_callbacks => true
  field :job_id, :type => String
  field :caption, :type => String

  attachment_field :original # only used to set original_size, original file is *not* stored

  validates_presence_of :caption

  image_attachment_fields :poster
  image_accessor :poster

  def storage_used
    calculate_storage_used_for(:poster) + calculate_storage_used_for(:original)
  end
end

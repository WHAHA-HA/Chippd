class GenericPdf < PageSectionWithAttachments
  field :title, :type => String
  attachment_fields :file

  image_accessor :file

  validates :title, :presence => true

  def storage_used
    calculate_storage_used_for(:file)
  end
end

class Track
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Orderable
  include AttachmentField

  embedded_in :playlist

  field :name, :type => String
  field :job_id, :type => String

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

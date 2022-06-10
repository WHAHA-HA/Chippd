class BabyImage
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Orderable
  include AttachmentField

  embedded_in :before_baby

  field :caption, :type => String

  image_attachment_fields :original, :image

  image_accessor :original do
    copy_to(:image) do |a|
      if a.width > a.height
        a.thumb('585x404#').process(:auto_orient)
      else
        a.thumb('585x404>').process(:auto_orient).process(:place_on_frame_canvas)
      end
    end
  end
  image_accessor :image

  orderable

  default_scope order_by(:position.asc)

  # Note: we are intentionally not including the storage size
  # of image to avoid confusion over discrepancies between the
  # file uploaded and the reported space used in the UI.
  def storage_used
    calculate_storage_used_for(:original)
  end
end

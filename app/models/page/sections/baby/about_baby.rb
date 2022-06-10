class AboutBaby < PageSectionWithAttachments

  field :name,     :type => String
  field :birthday, :type => Date
  field :weight,   :type => String
  field :height,   :type => String

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

  validates_presence_of :name
  validates_presence_of :weight
  validates_presence_of :height

  def formatted_birthday
    self.birthday ? self.birthday.stamp('2013-11-30') : ''
  end

  # Note: we are intentionally not including the storage size
  # of image to avoid confusion over discrepancies between
  # the file uploaded and the reported space used in the UI.
  def storage_used
    calculate_storage_used_for(:original)
  end

end

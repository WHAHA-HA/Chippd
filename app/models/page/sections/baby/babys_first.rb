class BabysFirst < PageSectionWithAttachments
  embeds_many :versions, :class_name => "VideoVersion", :cascade_callbacks => true

  field :media_type, :type => String # photo or video
  field :job_id,     :type => String
  field :caption,    :type => String

  image_attachment_fields :original, :image, :poster
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
  image_accessor :poster

  def photo?
    media_type == 'photo'
  end

  def video?
    media_type == 'video'
  end

  def asset_json
    if photo? && image_uid.present?
      {
        id:  image_uid,
        url: image.remote_url
      }.to_json
    elsif video? && versions.present?
      {
        id:  versions.last.id,
        url: versions.last.id
      }.to_json
    else
      {}
    end
  end

  def storage_used
    if photo?
      calculate_storage_used_for(:original)
    elsif video?
      calculate_storage_used_for(:poster) + calculate_storage_used_for(:original)
    end
  end
end

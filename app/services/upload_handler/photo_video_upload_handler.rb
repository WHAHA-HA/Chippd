class PhotoVideoUploadHandler < UploadHandler
  include TranscodingSupport

  def handle

    if section.photo? && has_upload_photo?

      section.original_url  = photo_url
      section.original_size = photo_original_size
      section.activate!
      notify_client

    elsif section.video? && has_upload_video?

      job = create_video_job(video_url)
      section.update_attributes!(job_id: job.data[:job][:id], original_size: video_original_size)
      # video processing needed... activate will happen in post_processing_handler

    end

  rescue => e
    notify_client(false) if section.photo?
    raise_processing_exception!(e)
  end

  protected

  def photo_url
    upload_params[:upload_photo].first['url']
  end

  def video_url
    upload_params[:upload_video].first['url']
  end

  def photo_original_size
    upload_params[:upload_photo].first['uploadSize']
  end

  def video_original_size
    upload_params[:upload_video].first['uploadSize']
  end

  def has_upload_photo?
    upload_params[:upload_photo].present?
  end

  def has_upload_video?
    upload_params[:upload_video].present?
  end

end

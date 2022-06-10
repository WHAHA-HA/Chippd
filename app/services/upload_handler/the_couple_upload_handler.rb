class TheCoupleUploadHandler < UploadHandler
  def has_upload_bride?
    upload_params[:upload_bride].present?
  end

  def has_upload_groom?
    upload_params[:upload_groom].present?
  end

  def handle
    section.bride_image_url = upload_params[:upload_bride].first['url'] if has_upload_bride?
    section.groom_image_url = upload_params[:upload_groom].first['url'] if has_upload_groom?
    section.activate!
    notify_client
  rescue => e
    notify_client(false)
    raise_processing_exception!(e)
  end
end

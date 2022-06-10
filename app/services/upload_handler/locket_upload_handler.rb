class LocketUploadHandler < UploadHandler
  def has_upload_one?
    upload_params[:upload_one].present?
  end

  def has_upload_two?
    upload_params[:upload_two].present?
  end

  def handle
    section.image_one_url = upload_params[:upload_one].first['url'] if has_upload_one?
    section.image_two_url = upload_params[:upload_two].first['url'] if has_upload_two?
    section.activate!
    notify_client
  rescue => e
    notify_client(false)
    raise_processing_exception!(e)
  end
end

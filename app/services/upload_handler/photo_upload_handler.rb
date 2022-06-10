class PhotoUploadHandler < UploadHandler
  def handle
    section.original_url = upload_params[:upload].first['url']
    section.activate!
    notify_client
  rescue => e
    notify_client(false)
    raise_processing_exception!(e)
  end
end

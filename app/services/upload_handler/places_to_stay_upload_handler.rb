class PlacesToStayUploadHandler < UploadHandler
  def handle
    section.featured_place.original_url = upload_params[:upload].first['url']
    section.featured_place.save
    section.activate!
    notify_client
  rescue => e
    notify_client(false)
    raise_processing_exception!(e)
  end
end

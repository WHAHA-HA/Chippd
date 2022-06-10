class VideoUploadHandler < UploadHandler
  include TranscodingSupport

  def handle
    job = create_video_job(url)
    section.update_attributes!(job_id: job.data[:job][:id], original_size: original_size)
  rescue => e
    raise_processing_exception!(e)
  end

  protected

  def url
    upload_params[:upload].first['url']
  end

  def original_size
    upload_params[:upload].first['uploadSize']
  end

end

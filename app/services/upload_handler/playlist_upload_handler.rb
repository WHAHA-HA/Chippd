class PlaylistUploadHandler < UploadHandler
  include TranscodingSupport

  def handle
    processing_required = false
    upload_params[:upload].each do |upload|
      id, url, other_data = upload['id'], upload['url'], data(upload)

      if id.blank? && url
        create(url, other_data)
        processing_required = true
      elsif id && url.blank?
        destroy(id)
      elsif url_modified?(id, url)
        update_track(id, url, other_data)
        processing_required = true
      else
        update(id, other_data)
      end
    end
    unless processing_required
      section.activate!
      notify_client
    end
  rescue => e
    raise_processing_exception!(e)
  end

  protected

  def existing
    @existing ||= section.tracks.map(&:to_param)
  end

  def data(hash)
    {
      name:          hash['name'],
      original_size: hash['uploadSize']
    }
  end

  def track(id)
    section.tracks.where(id: id).first
  end

  def url_modified?(id, url)
    existing.include?(id) && url.include?(configatron.s3.upload_bucket_name)
  end

  def create(url, data)
    job = create_audio_job(url)
    section.tracks.create!(data.merge(job_id: job.data[:job][:id]))
  end

  def update(id, data)
    track(id).update_attributes!(data)
  end

  def update_track(id, url, data)
    job = create_audio_job(url)
    update(id, data.merge(job_id: job.data[:job][:id], file_uid: nil))
  end

  def destroy(id)
    track(id).destroy
  end

end

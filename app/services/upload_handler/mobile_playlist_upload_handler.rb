class MobilePlaylistUploadHandler < PlaylistUploadHandler

  protected

  def existing
    @existing ||= section.mobile_tracks.map(&:to_param)
  end

  def track(id)
    section.mobile_tracks.where(id: id).first
  end

  def create(url, data)
    job = create_audio_job(url)
    section.mobile_tracks.create!(data.merge(job_id: job.data[:job][:id]))
  end

end

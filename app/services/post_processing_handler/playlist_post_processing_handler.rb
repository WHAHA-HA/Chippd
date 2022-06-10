class PlaylistPostProcessingHandler < PostProcessingHandler
  def handle
    case state
    when 'COMPLETED'
      track = tracks.where(job_id: job_id).first
      track.update_attribute(:file_uid, "#{filepath}.mp3") if track
      if all_tracks_processed?
        section.activate!
        notify_client
      end
    when 'ERROR'
      section.error!
      notify_client(false)
    end
  rescue => e
    notify_client(false)
    raise_processing_exception!(e)
  end

  protected

  def tracks
    section.tracks
  end

  def all_tracks_processed?
    return false if section.error?
    tracks.each do |track|
      return false if track.file_uid.blank?
    end
    true
  end

end

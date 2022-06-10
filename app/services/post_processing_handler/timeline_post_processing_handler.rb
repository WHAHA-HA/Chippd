class TimelinePostProcessingHandler < PostProcessingHandler
  include VideoSupport

  def handle
    case state
    when 'COMPLETED'
      if asset = video_assets.where(job_id: job_id).first
        handle_video(asset)
      elsif asset = audio_assets.where(job_id: job_id).first
        handle_audio(asset)
      end
      if all_video_assets_processed? && all_audio_assets_processed?
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

  def handle_video(asset)
    asset.poster_url = poster_url
    versions.each do |version|
      asset.versions.create(:preset => version, :file_uid => video_location_for(version), :codec => codec_for(version))
    end
  end

  def handle_audio(asset)
    asset.update_attributes!(audio_file_uid: "#{filepath}.mp3")
  end

  protected

  def video_assets
    section.timeline_assets.videos
  end

  def audio_assets
    section.timeline_assets.tracks
  end

  def all_video_assets_processed?
    return false if section.error?
    video_assets.each do |asset|
      return false if asset.versions.blank?
    end
    true
  end

  def all_audio_assets_processed?
    return false if section.error?
    audio_assets.each do |asset|
      return false if asset.audio_file_uid.blank?
    end
    true
  end

end

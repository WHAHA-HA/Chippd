class VideoPostProcessingHandler < PostProcessingHandler
  include VideoSupport

  def handle
    case state
    when 'COMPLETED'
      section.poster_url = poster_url
      versions.each do |version|
        section.versions.create(:preset => version, :file_uid => video_location_for(version), :codec => codec_for(version))
      end
      section.activate!
      notify_client
    when 'ERROR'
      section.error!
      notify_client(false)
    end
  rescue => e
    notify_client(false)
    raise_processing_exception!(e)
  end

end

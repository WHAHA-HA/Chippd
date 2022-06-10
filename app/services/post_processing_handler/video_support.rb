module VideoSupport

  def versions
    %w(ipad_video iphone_video webm_video hls_video)
  end

  def poster_url
    # amazon doesn't send back url's to thumbnails for some reason...
    "#{configatron.s3.base_url}/#{configatron.s3.bucket_name}/#{filepath}_00001.png"
  end

  def video_location_for(version)
    case version
      when 'ipad_video'   then "#{filepath}_adv.mp4"
      when 'iphone_video' then "#{filepath}_uni.mp4"
      when 'webm_video'   then "#{filepath}.webm"
      when 'hls_video'    then "#{filepath}.hls"
    end
  end

  def codec_for(version)
    case version
      when 'ipad_video'   then 'video/mp4; codecs="h264,aac"'
      when 'iphone_video' then 'video/mp4; codecs="h264,aac"'
      when 'webm_video'   then 'video/webm; codecs="vp8,vorbis"'
      when 'hls_video'    then 'application/x-mpegURL; codecs="h264,aac"'
    end
  end

end

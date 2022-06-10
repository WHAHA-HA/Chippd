class TimelineUploadHandler < UploadHandler
  include TranscodingSupport

  def handle
    handle_photos
    audio_processing_needed = handle_tracks
    video_processing_needed = handle_videos
    # if audio or video processing needed, activate will happen in post_processing_handler
    unless audio_processing_needed || video_processing_needed
      section.activate!
      notify_client
    end
  rescue => e
    notify_client(false)
    raise_processing_exception!(e)
  end

  def handle_photos
    photos.each do |photo|
      id, url, other_data = photo['id'], photo['url'], data(photo)

      if id.blank? && url
        create(other_data.merge(original_url: url))
      elsif id && url.blank?
        destroy(id)
      elsif url_modified?(id, url)
        update(id, other_data.merge(original_url: url))
      else
        update(id, other_data)
      end
    end
  end

  def handle_tracks
    processing_required = false
    tracks.each do |track|
      id, url, other_data = track['id'], track['url'], data(track)

      if id.blank? && url
        create_track(url, other_data)
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
    processing_required
  end

  def handle_videos
    processing_required = false
    videos.each do |video|
      id, url, other_data = video['id'], video['url'], data(video)

      if id.blank? && url
        create_video(url, other_data)
        processing_required = true
      elsif id && url.blank?
        destroy(id)
      elsif url_modified?(id, url)
        update_video(id, url, other_data)
        processing_required = true
      else
        update(id, other_data)
      end
    end
    processing_required
  end

  private

  def data(hash)
    {
      media_type:    hash['media_type'],
      timeframe:     hash['timeframe'],
      heading:       hash['heading'],
      description:   hash['description'],
      track_name:    hash['track_name'],
      original_size: hash['uploadSize']
    }
  end

  def photos
    @photos ||= upload_params[:upload].select { |v| v.values_at('media_type').include?('photo') }
  end

  def videos
    @videos ||= upload_params[:upload].select { |v| v.values_at('media_type').include?('video') }
  end

  def tracks
    @tracks ||= upload_params[:upload].select { |v| v.values_at('media_type').include?('audio') }
  end

  def existing
    @existing ||= section.timeline_assets.map(&:to_param)
  end

  def asset(id)
    section.timeline_assets.where(id: id).first
  end

  def create(data)
    section.timeline_assets.create!(data)
  end

  def url_modified?(id, url)
    existing.include?(id) && url.include?(configatron.s3.upload_bucket_name)
  end

  def update(id, data)
    asset(id).update_attributes!(data)
  end

  def create_video(url, data)
    job = create_video_job(url)
    create(data.merge(job_id: job.data[:job][:id]))
  end

  def update_video(id, url, data)
    job = create_video_job(url)
    update(id, data.merge(job_id: job.data[:job][:id]))
  end

  def create_track(url, data)
    job = create_audio_job(url)
    create(data.merge(job_id: job.data[:job][:id]))
  end

  def update_track(id, url, data)
    job = create_audio_job(url)
    update(id, data.merge(job_id: job.data[:job][:id]))
  end

  def destroy(id)
    asset(id).destroy
  end

end

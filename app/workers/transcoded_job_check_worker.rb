class TranscodedJobCheckWorker < ProcessingWorker
  def perform
    job_section = {}
    # { :job_id => :section_id }
    Page.with_pending_sections.each do |page|
      page.sections.each do |section|

        if section.is_a?(PageSectionWithAttachments) && section.pending?
          case section
          when Playlist
            section.tracks.map(&:job_id).each do |job_id|
              job_section[job_id] = section.to_param
            end
          when Video
            job_section[section.job_id] = section.to_param
          when MobilePlaylist
            section.mobile_tracks.map(&:job_id).each do |job_id|
              job_section[job_id] = section.to_param
            end
          when BabysFirst
            job_section[section.job_id] = section.to_param if section.video?
          when Timeline
            assets = section.timeline_assets
            assets.videos.map(&:job_id).each do |job_id|
              job_section[job_id] = section.to_param
            end
            assets.tracks.map(&:job_id).each do |job_id|
              job_section[job_id] = section.to_param
            end
          when Auction
            job_section[section.job_id] = section.to_param if section.video?
          end
        end

      end
    end

    unless job_section.blank?
      #p "pending jobs: #{job_section.inspect}"
      poller = AwsPoller.new(job_section)
      poller.poll_and_handle_messages
    end
  end
end

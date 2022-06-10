class EmbeddedVideo < PageSection
  field :video_url, :type => String
  field :caption, :type => String

  validates :caption, :presence => true
  validates :video_url, :presence => true,
            :format => {
              :with => URI::regexp(%w(http https)),
              :message => "must be a properly formatted URL e.g. http://google.com",
              :allow_blank => false
            }
  validate :video_source_is_acceptable

  def parsed_video_url
    @parsed_video_url ||= URI.parse(video_url)
  end

  def video_type
    if parsed_video_url.host.include?('youtube.com')
      :youtube
    elsif parsed_video_url.host.include?('vimeo.com')
      :vimeo
    else
      nil
    end
  end

  def video_id
    if video_type == :youtube
      CGI.parse(parsed_video_url.query)['v'].first
    elsif video_type == :vimeo
      parsed_video_url.path.gsub('/', '')
    else
      nil
    end
  end

  def video_source_is_acceptable
    if video_url.present?
      errors.add(:video_url, "must be from either YouTube or Vimeo") unless video_type
    end
  end

  def uses_storage?
    false
  end
end

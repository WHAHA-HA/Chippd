class EmbeddedAudio < PageSection
  field :audio_url, :type => String
  field :caption,   :type => String

  validates :caption,   :presence => true
  validates :audio_url, :presence => true,
            :format => {
              :with => URI::regexp(%w(http https)),
              :message => "must be a properly formatted URL e.g. http://google.com",
              :allow_blank => false
            }
  validate :audio_source_is_acceptable

  def parsed_audio_url
    @parsed_audio_url ||= URI.parse(audio_url)
  end

  def audio_type
    if parsed_audio_url.host.include?('soundcloud.com')
      :soundcloud
    else
      nil
    end
  end

  def audio_id
    if audio_type == :soundcloud
      parsed_audio_url
    else
      nil
    end
  end

  def audio_source_is_acceptable
    if audio_url.present?
      errors.add(:audio_url, "must be from SoundCloud") unless audio_type
    end
  end

  def uses_storage?
    false
  end
end

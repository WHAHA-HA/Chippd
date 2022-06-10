class Timeline < PageSectionWithAttachments
  MINIMUM_NUMBER_OF_ASSETS = 1
  MAXIMUM_NUMBER_OF_ASSETS = 10
  embeds_many :timeline_assets, :cascade_callbacks => true

  field :name_one,     :type => String
  field :name_two,     :type => String
  field :wedding_date, :type => Date

  validates_presence_of :name_one
  validates_presence_of :name_two

  def formatted_wedding_date
    self.wedding_date ? self.wedding_date.stamp('2013-11-30') : ''
  end

  def storage_used
    timeline_assets.sum(&:storage_used)
  end

  def timeline_assets_json
    timeline_assets.map do |asset|
      case
      when asset.photo?
        url = asset.original.remote_url
      when asset.video?
        url = asset.versions.first.file.remote_url
      when asset.audio?
        url = asset.audio_file.remote_url
      end
      {
        id:  asset.id,
        url: url,
        media_type:  asset.media_type,
        timeframe:   asset.timeframe,
        heading:     asset.heading,
        description: asset.description,
        track_name:  asset.track_name
      }
    end.to_json
  end

end

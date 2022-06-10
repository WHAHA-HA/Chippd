class Playlist < PageSectionWithAttachments
  MAXIMUM_NUMBER_OF_TRACKS = 10
  MINIMUM_NUMBER_OF_TRACKS = 1
  embeds_many :tracks, :cascade_callbacks => true

  field :title, :type => String

  validates_presence_of :title

  def storage_used
    tracks.sum(&:storage_used)
  end

  def tracks_json
    tracks.map do |track|
      if track.file
        {
          id: track.id,
          url: track.file.remote_url,
          name: track.name
        }
      end
    end.to_json
  end
end

class MobilePlaylist < PageSectionWithAttachments
  MAXIMUM_NUMBER_OF_TRACKS = 10
  MINIMUM_NUMBER_OF_TRACKS = 1
  embeds_many :mobile_tracks, :cascade_callbacks => true

  image_attachment_fields :original, :image

  image_accessor :original do
    copy_to(:image){|a| a.thumb('600x').process(:auto_orient) }
  end
  image_accessor :image

  field :title,          :type => String
  field :byline,         :type => String
  field :desc,           :type => String
  field :price_in_cents, :type => Integer
  field :purchaseable,   :type => Boolean, :default => false
  field :downloadable,   :type => Boolean, :default => false
  field :itunes_url,     :type => String
  field :amazon_url,     :type => String

  validates_presence_of :title

  def storage_used
    mobile_tracks.sum(&:storage_used)
  end

  def mobile_tracks_json
    mobile_tracks.map do |track|
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

class TimelineAsset
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Orderable
  include AttachmentField

  embedded_in :timeline
  embeds_many :versions, :class_name => "VideoVersion", :cascade_callbacks => true

  field :media_type,  :type => String # photo, video, audio
  field :job_id,      :type => String
  field :timeframe,   :type => String
  field :heading,     :type => String
  field :description, :type => String
  field :track_name,  :type => String

  validates_presence_of :timeframe
  validates_presence_of :heading
  validates_presence_of :description

  attachment_field :audio_file
  image_accessor :audio_file
  image_attachment_fields :original, :image, :poster
  image_accessor :original do
    copy_to(:image){|a| a.thumb('600x') }
  end
  image_accessor :image
  image_accessor :poster

  orderable

  scope :photos, where(media_type: 'photo')
  scope :videos, where(media_type: 'video')
  scope :tracks, where(media_type: 'audio')

  default_scope order_by(:position.asc)

  set_callback(:save, :before) do |document|
    if document.audio_file.present? && document.track_name.blank?
      document.track_name = File.basename(document.audio_file_uid, '.*')
    end
  end

  def photo?
    media_type == 'photo'
  end

  def video?
    media_type == 'video'
  end

  def audio?
    media_type == 'audio'
  end

  def storage_used
    if photo? || audio?
      calculate_storage_used_for(:original)
    elsif video?
      calculate_storage_used_for(:poster) + calculate_storage_used_for(:original)
    end
  end

end

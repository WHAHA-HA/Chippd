class Invitation < PageSectionWithAttachments
  field :intro,            :type => String, :default => 'Celebrate With Us'
  field :location_name,    :type => String
  field :location_address, :type => String
  field :happens_on,       :type => Date
  field :time,             :type => Time
  field :after,            :type => String
  field :note,             :type => String
  field :bride_name,       :type => String
  field :groom_name,       :type => String

  image_attachment_fields :image

  image_accessor :image do
    after_assign { |a| a.thumb!('300x300#') }
  end

  validates :intro, :presence => true, :length => {
    :maximum => configatron.character_limits.invitation.intro
  }
  validates :location_name, :presence => true, :length => {
    :maximum => configatron.character_limits.invitation.location_name
  }
  validates :location_address, :presence => true
  validates :happens_on, :presence => true
  validates :time, :presence => true
  validates :after, :length => {
    :maximum => configatron.character_limits.invitation.after,
    :allow_blank => true
  }
  validates :note, :length => {
    :maximum => configatron.character_limits.invitation.note,
    :allow_blank => true
  }
  validates :bride_name, :presence => true, :length => {
    :maximum => configatron.character_limits.invitation.bride_name
  }
  validates :groom_name, :presence => true, :length => {
    :maximum => configatron.character_limits.invitation.groom_name
  }

  def formatted_happens_on
    self.happens_on ? self.happens_on.stamp('2013-11-30') : ''
  end

  def formatted_time
    self.time ? self.time.stamp('11:00 PM') : ''
  end

  def storage_used
    calculate_storage_used_for(:image)
  end
end

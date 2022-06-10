class RsvpResponse
  include Mongoid::Document
  include Mongoid::Timestamps

  MINIMUM_NUMBER_OF_GUESTS = 1

  belongs_to :customer
  embedded_in :rsvp, :inverse_of => :responses
  embeds_many :guests, :class_name => 'RsvpResponseGuest'

  field :attending, :type => Boolean, :default => true

  accepts_nested_attributes_for :guests, :allow_destroy => true, :reject_if => proc { |attributes| attributes['name'].blank? }
  validates :guests, :length => {
    :minimum => MINIMUM_NUMBER_OF_GUESTS,
    :message => "must have at least #{MINIMUM_NUMBER_OF_GUESTS}."
  }

  scope :yes, where(:attending => true)
  scope :no, where(:attending => false)

  def build_guests(default_name)
    if self.guests.blank?
      self.guests.build(:name => default_name)
    end
  end
end

class RsvpResponseGuest
  include Mongoid::Document
  include Mongoid::Timestamps
  embedded_in :rsvp_response, :inverse_of => :guests

  field :name, :type => String
  field :meal, :type => String, :default => 'No Preference'

  validates :name, :presence => true
end

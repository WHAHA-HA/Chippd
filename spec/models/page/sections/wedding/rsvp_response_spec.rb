require 'spec_helper'

describe RsvpResponse do
  it { should be_mongoid_document }
  it { should be_timestamped_document }

  it { should belong_to(:customer) }
  it { should be_embedded_in(:rsvp).as_inverse_of(:responses) }
  it { should embed_many(:guests).of_type(RsvpResponseGuest) }

  it { should have_field(:attending).of_type(Boolean).with_default_value_of(true) }

  it { should validate_length_of(:guests).with_minimum(1) }
end

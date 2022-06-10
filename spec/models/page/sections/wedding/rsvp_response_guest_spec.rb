require 'spec_helper'

describe RsvpResponseGuest do
  it { should be_mongoid_document }
  it { should be_timestamped_document }

  it { should be_embedded_in(:rsvp_response).as_inverse_of(:guests) }

  it { should have_field(:name).of_type(String) }
  it { should have_field(:meal).of_type(String) }

  it { should validate_presence_of(:name) }
end

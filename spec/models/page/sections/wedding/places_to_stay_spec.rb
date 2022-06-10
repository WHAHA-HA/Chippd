require 'spec_helper'

describe PlacesToStay do
  it { should be_a(PageSectionWithAttachments) }
  it { should embed_many(:places).of_type(PlaceToStay) }
  it { should have_field(:when_booking).of_type(String) }
end

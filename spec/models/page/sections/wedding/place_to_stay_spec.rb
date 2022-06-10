require 'spec_helper'

describe PlaceToStay do
  it { should be_mongoid_document }
  it { should be_timestamped_document }

  it { should be_embedded_in(:places_to_stay).as_inverse_of(:places) }

  it { should have_field(:name).of_type(String) }
  it { should have_field(:price).of_type(Integer).with_default_value_of(1) }
  it { should have_field(:url).of_type(String) }
  it { should have_field(:image_uid).of_type(String) }

  [:name, :price, :url].each do |attr|
    it { should validate_presence_of(attr) }
  end

  describe "#storage_used" do
    let(:place_to_stay) { PlaceToStay.new(:original_size => 1, :image_size => 2, :thumb_size => 3) }
    subject { place_to_stay.storage_used }
    it { should be(1) }
  end
end

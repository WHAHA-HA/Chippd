require 'spec_helper'

describe LandingPageImage do
  it { should be_mongoid_document }
  it { should be_timestamped_document }
  it { should have_visibility }
  it { should be_sortable }

  it { should be_embedded_in(:landing_page).as_inverse_of(:images) }

  it { should have_field(:caption).of_type(String) }
  it { should have_field(:original_uid).of_type(String) }
  it { should have_field(:large_uid).of_type(String) }
  it { should have_field(:medium_uid).of_type(String) }
  it { should have_field(:small_uid).of_type(String) }
  it { should have_field(:image_uid).of_type(String) }

  [:caption, :original].each do |attr|
    it { should validate_presence_of(attr) }
  end
end

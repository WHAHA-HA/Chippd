require 'spec_helper'

describe LandingPageStep do
  it { should be_mongoid_document }
  it { should be_timestamped_document }
  it { should have_visibility }
  it { should be_sortable }

  it { should be_embedded_in(:landing_page).as_inverse_of(:steps) }

  it { should have_field(:title).of_type(String) }
  it { should have_field(:description).of_type(String) }
  it { should have_field(:image_uid).of_type(String) }
  it { should have_field(:original_uid).of_type(String) }

  [:title, :description, :original].each do |attr|
    it { should validate_presence_of(attr) }
  end
end

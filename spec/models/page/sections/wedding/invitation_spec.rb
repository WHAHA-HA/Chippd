require 'spec_helper'

describe Invitation do
  it { should be_a(PageSectionWithAttachments) }

  it { should have_field(:intro).of_type(String) }
  it { should have_field(:location_name).of_type(String) }
  it { should have_field(:location_address).of_type(String) }
  it { should have_field(:happens_on).of_type(Date) }
  it { should have_field(:time).of_type(Time) }
  it { should have_field(:after).of_type(String) }
  it { should have_field(:note).of_type(String) }
  it { should have_field(:image_uid).of_type(String) }

  [:intro, :location_name, :location_address, :happens_on, :time].each do |attr|
    it { should validate_presence_of(attr) }
  end
end

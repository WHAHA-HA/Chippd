require 'spec_helper'

describe TheCouple do
  it { should be_a(PageSectionWithAttachments) }
  it { should have_field(:bride_name).of_type(String) }
  it { should have_field(:bride_parents).of_type(String) }
  it { should have_field(:bride_bio).of_type(String) }
  it { should have_field(:bride_image_uid).of_type(String) }
  it { should have_field(:groom_name).of_type(String) }
  it { should have_field(:groom_parents).of_type(String) }
  it { should have_field(:groom_bio).of_type(String) }
  it { should have_field(:groom_image_uid).of_type(String) }

  [:bride_name, :bride_parents, :bride_bio, :groom_name, :groom_parents, :groom_bio].each do |attr|
    it { should validate_presence_of(attr) }
  end
end

require 'spec_helper'

describe Vcard do
  it { should be_a(PageSection) }

  it { should have_field(:name).of_type(String) }
  it { should have_field(:company).of_type(String) }
  it { should have_field(:email).of_type(String) }
  it { should have_field(:phone).of_type(String) }
  it { should have_field(:address).of_type(String) }
  it { should have_field(:city).of_type(String) }
  it { should have_field(:state).of_type(String) }
  it { should have_field(:postal_code).of_type(String) }
  it { should have_field(:country).of_type(String).with_default_value_of('United States') }
  it { should have_field(:link_to_map).of_type(Boolean).with_default_value_of(true) }
  it { should have_field(:link_to_vcard).of_type(Boolean).with_default_value_of(true) }
  it { should have_field(:image_uid).of_type(String) }

  it { should validate_presence_of(:name) }
end

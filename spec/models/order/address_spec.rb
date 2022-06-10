require 'spec_helper'

describe Address do
  it { should be_mongoid_document }
  it { should be_embedded_in(:order) }

  it { should have_field(:first_name).of_type(String) }
  it { should have_field(:last_name).of_type(String) }
  it { should have_field(:address_1).of_type(String) }
  it { should have_field(:address_2).of_type(String) }
  it { should have_field(:city).of_type(String) }
  it { should have_field(:state).of_type(String) }
  it { should have_field(:postal_code).of_type(String) }
  it { should have_field(:country).of_type(String).with_default_value_of('United States') }

  [:first_name, :last_name, :address_1, :city, :state, :postal_code, :country].each do |attr|
    it { should validate_presence_of(attr) }
  end
end

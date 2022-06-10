require 'spec_helper'

describe GiftRegistrySource do
  it { should be_mongoid_document }
  it { should be_timestamped_document }

  it { should be_embedded_in(:gift_registry).as_inverse_of(:sources) }

  it { should have_field(:name).of_type(String) }
  it { should have_field(:url).of_type(String) }

  [:name, :url].each do |attr|
    it { should validate_presence_of(attr) }
  end
end

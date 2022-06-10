require 'spec_helper'

describe Discount do
  it { should be_mongoid_document }
  it { should be_timestamped_document }
  it { should have_visibility }

  it { should have_field(:name).of_type(String) }
  it { should have_field(:code).of_type(String) }

  [:name, :code].each do |attr|
    it { should validate_presence_of(attr) }
  end
end

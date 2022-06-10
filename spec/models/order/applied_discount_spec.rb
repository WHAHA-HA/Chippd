require 'spec_helper'

describe AppliedDiscount do
  it { should be_mongoid_document }
  it { should be_embedded_in(:order) }
  it { should belong_to(:discount) }

  it { should have_field(:amount_in_cents).of_type(Integer).with_default_value_of(0) }
  it { should have_field(:name).of_type(String) }
  it { should have_field(:code).of_type(String) }

  [:discount, :code].each do |attr|
    it { should validate_presence_of(attr) }
  end
end

require 'spec_helper'

describe PaymentCard do
  it { should be_mongoid_document }
  it { should be_embedded_in(:order) }

  it { should have_field(:brand).of_type(String) }
  it { should have_field(:last4).of_type(String) }
  it { should have_field(:exp_month).of_type(String) }
  it { should have_field(:exp_year).of_type(String) }
end

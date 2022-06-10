require 'spec_helper'

describe Code do
  it { should be_mongoid_document }
  it { should belong_to(:batch) }

  it { should have_field(:value).of_type(String) }
  it { should have_field(:redeem).of_type(String) }
  it { should have_field(:used).of_type(Boolean).with_default_value_of(false) }

  describe "#redeem!" do
    let(:code) { FactoryGirl.create(:code) }
    let(:customer) { FactoryGirl.create(:customer) }

    subject { code.redeem!(customer.to_param) }

    it "should set the code to used" do
      expect {
        subject
      }.to change { code.used }.from(false).to(true)
    end

    it "should set the redeemer to the customer id passed in" do
      expect {
        subject
      }.to change { code.redeemed_by }.from(nil).to(customer)
    end
  end
end
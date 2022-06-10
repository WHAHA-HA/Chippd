require 'spec_helper'

describe RedeemRetailCode do
  let(:customer_id) { 1 }
  let(:code) { double('code', :to_param => 1, :redeem! => true) }
  let(:chippd_product_type_id) { 1 }

  before do
    CodeByRedeemQuery.stub(:call).and_return(code)
    RetailPageBuilder.stub(:call).and_return(true)
  end

  subject { described_class.call(customer_id, code.to_param, chippd_product_type_id) }

  describe ".call" do
    it "should look up the code passed in" do
      CodeByRedeemQuery.should_receive(:call).with(code.to_param).and_return(code)
      subject
    end

    it "should look up the code passed in" do
      RetailPageBuilder.should_receive(:call).with(customer_id, code.to_param, chippd_product_type_id).and_return(true)
      subject
    end

    it "should mark the code redeemed" do
      code.should_receive(:redeem!).with(customer_id)
      subject
    end
  end
end
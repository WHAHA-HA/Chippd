require 'spec_helper'

describe RedeemGiftCode do
  # let(:customer_id) { 1 }
  # let(:code) { 1 }
  # let(:chippd_product_type_id) { 1 }
  # let(:redeem_class) { double(:call => true) }
  # let(:verifier) { double(:pass? => true, :redeem_class => redeem_class) }

  # before do
  #   VerifyRedeemCode.stub(:call).and_return(verifier)
  # end

  # subject { described_class.call(customer_id, code, chippd_product_type_id) }

  # describe ".call" do
  #   it "should call the verifier with the code passed in" do
  #     VerifyRedeemCode.should_receive(:call).with(code).and_return(verifier)
  #     subject
  #   end

  #   it "should check that the verifier passes" do
  #     verifier.should_receive(:pass?)
  #     subject
  #   end

  #   context "when verification passes" do
  #     it "should call the redeem class" do
  #       redeem_class.should_receive(:call).with(customer_id, code, chippd_product_type_id)
  #       subject
  #     end
  #   end

  #   context "when the verification does not pass" do
  #     let(:verifier) { double(:pass? => false) }
  #     it { should be_false }
  #   end
  # end
end
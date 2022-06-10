require 'spec_helper'

describe ShippingOptionQuery do
  subject { described_class.call(order) }

  context "when the order qualifies for greeting card shipping" do
    let(:order) { double('order', :qualifies_for_greeting_card_shipping? => true) }

    it "returns options that include greeting card only" do
      expect(subject.any?(&:greeting_card_only?)).to be_true
    end

    it "returns options that are not greeting card only" do
      expect(subject.any? { |o| !o.greeting_card_only? }).to be_true
    end
  end

  context "when the order does not qualify for greeting card shipping" do
    let(:order) { double('order', :qualifies_for_greeting_card_shipping? => false) }

    it "returns options that are not greeting card only" do
      expect(subject.none?(&:greeting_card_only?)).to be_true
    end
  end
end
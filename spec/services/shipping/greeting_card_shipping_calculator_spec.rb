require 'spec_helper'

describe GreetingCardShippingCalculator do
  let(:order) { double('order') }

  subject { described_class.new(order) }

  it { should be_a(ShippingCalculator) }

  describe "#calculate!" do
    subject { described_class.new(order).calculate! }

    it "returns a Money object" do
      expect(subject).to be_a(Money)
    end

    it "returns the correct rate" do
      expect(subject).to eq(Money.new(200))
    end
  end
end
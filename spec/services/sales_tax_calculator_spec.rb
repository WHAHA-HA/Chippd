require 'spec_helper'

describe SalesTaxCalculator do
  let(:address) { double('address', :state => 'NY') }
  let(:order) { double('order', :subtotal_in_cents => 100, :shipping_address => address) }

  before do
    configatron.stub(:sales_tax_rate).and_return(0.05)
  end

  describe "#calculate" do
    subject { described_class.new(order).calculate }

    it { should be_a(Money) }

    context "when the order qualifies for sales tax" do
      it { should == Money.new(5, configatron.default_currency)}
    end

    context "when the order doesn't qualify for sales tax" do
      let(:address) { double('address', :state => 'CA') }
      it { should == Money.new(0, configatron.default_currency)}
    end
  end
end

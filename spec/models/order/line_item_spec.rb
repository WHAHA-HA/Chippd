require 'spec_helper'

describe LineItem do
  it { should be_mongoid_document }

  it { should be_embedded_in(:order) }

  it { should belong_to(:product) }
  it { should belong_to(:chippd_product_type) }

  it { should have_field(:product_name).of_type(String) }
  it { should have_field(:chippd_product_type_name).of_type(String) }
  it { should have_field(:price_each_in_cents).of_type(Integer).with_default_value_of(0) }
  it { should have_field(:key).of_type(String) }
  it { should have_field(:quantity).of_type(Integer).with_default_value_of(1) }
  it { should have_field(:options).of_type(Array).with_default_value_of([]) }

  [:price_each_in_cents, :quantity].each do |attr|
    it { should validate_presence_of(attr) }
  end
  [:price_each_in_cents, :quantity].each do |attr|
    it { should validate_numericality_of(attr) }
  end

  # describe "#subtotal" do
  #   subject { Order.new.subtotal }
  #   it { should be_a(Money) }
  # end
  #
  # describe "#subtotal=" do
  #   let(:order) { Order.new(:subtotal => 12.99)}
  #
  #   describe "change of #subtotal_in_cents" do
  #     subject { order.subtotal_in_cents }
  #     it { should == 1299 }
  #   end
  # end
end

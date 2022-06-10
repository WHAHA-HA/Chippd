require 'spec_helper'

describe Order do
  it { should be_mongoid_document }
  it { should be_timestamped_document }

  it { should embed_many(:line_items) }

  it { should have_field(:subtotal_in_cents).of_type(Integer).with_default_value_of(0) }

  describe "#subtotal" do
    subject { Order.new.subtotal }
    it { should be_a(Money) }
  end

  describe "#subtotal=" do
    let(:order) { Order.new(:subtotal => 12.99)}

    describe "change of #subtotal_in_cents" do
      subject { order.subtotal_in_cents }
      it { should == 1299 }
    end
  end

  describe "#qualifies_for_greeting_card_shipping?" do
    let(:bracelet) { Product.new(:greeting_card => false) }
    let(:greeting_card) { Product.new(:greeting_card => true) }
    subject { order.qualifies_for_greeting_card_shipping? }

    context "there are not greeting cards in the order" do
      let(:order) { Order.new }
      it { should be_false }
    end

    context "there are only greeting cards" do
      context "but there are more than 2" do
        let(:order) { Order.new(:line_items => [LineItem.new(:quantity => 2, :product => greeting_card), LineItem.new(:quantity => 1, :product => greeting_card)]) }
        it { should be_false }
      end

      context "and there are 2 or less" do
        let(:order) { Order.new(:line_items => [LineItem.new(:quantity => 2, :product => greeting_card)]) }
        it { should be_true }
      end
    end

    context "there are greeting cards and other products" do
      context "but there are more than 2" do
        let(:order) { Order.new(:line_items => [LineItem.new(:quantity => 2, :product => greeting_card), LineItem.new(:quantity => 1, :product => bracelet)]) }
        it { should be_false }
      end
    end
  end
  
  describe "pages" do
    let(:bracelet) { Product.new(:greeting_card => false) }
    let(:greeting_card) { Product.new(:greeting_card => true) }
    let(:customer) { FactoryGirl.create(:customer) }
    let(:order) { Order.create(:customer => customer, :line_items => [LineItem.new(:quantity => 2, :product => greeting_card), LineItem.new(:quantity => 1, :product => bracelet)]) }
    let(:line_item1) { order.line_items.first }
    let(:line_item2) { order.line_items.last }
    
    before do
      [line_item1, line_item2].each do |line_item|
        customer.pages.create(:product_collection_id => line_item.product_collection_id, :chippd_product_type_id => line_item.chippd_product_type_id, :page_template_id => line_item.page_template_id, :line_items => [PageLineItem.from_order_line_item(line_item)])
      end
    end
    
    it "should have pages" do
      order.pages.length.should == 2
    end
    
    it "should be destroyed on cancel" do
      mailer = double()
      mailer.stub(:deliver)
      OrderMailer.stub(:canceled).and_return(mailer)
      expect{ order.cancel! }.to change{order.pages.length}.from(2).to(0)
    end
  end
end

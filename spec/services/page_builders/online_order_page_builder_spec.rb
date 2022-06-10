require 'spec_helper'

describe OnlineOrderPageBuilder do
  let(:page) { double('page', :chippd_product_type_id => 123) }
  let(:pages) { double('pages', :find => page) }
  let(:line_item) { double('line item') }
  let(:customer) { double('customer', :to_param => 1, :pages => pages) }
  let(:order) { double('order', :to_param => 1, :line_items => [line_item], :chippd_product_type_id => 123) }
  let(:existing_page_id) { 1 }

  before do
    Customer.stub(:find).and_return(customer)
    Order.stub(:find).and_return(order)
    OrderLineItemPageBuilder.stub(:call).and_return(true)
  end

  subject { described_class.call(customer.to_param, order.to_param) }

  describe ".call" do
    it "should lookup the customer" do
      Customer.should_receive(:find).with(customer.to_param)
      subject
    end

    it "should lookup the order" do
      Order.should_receive(:find).with(order.to_param)
      subject
    end

    context "when an existing page id is passed in" do
      subject { described_class.call(customer.to_param, order.to_param, existing_page_id) }

      it "should lookup a page with that id" do
        pages.should_receive(:find).with(existing_page_id)
        subject
      end

      context "when an existing page is found" do
        context "when the page's product id matches the order's" do
          it "should pass a page object along" do
            OrderLineItemPageBuilder.should_receive(:call).with(customer, line_item, page)
            subject
          end
        end

        context "when the page's product id does not match the order's" do
          let(:page) { double('page', :chippd_product_type_id => 1) }

          it "should not pass a page object along" do
            OrderLineItemPageBuilder.should_receive(:call).with(customer, line_item, nil)
            subject
          end
        end
      end

      context "when an existing page is not found" do
        let(:pages) { double('pages', :find => nil) }

        it "should not pass a page object along" do
          OrderLineItemPageBuilder.should_receive(:call).with(customer, line_item, nil)
          subject
        end
      end
    end
  end
end
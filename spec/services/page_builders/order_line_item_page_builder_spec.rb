require 'spec_helper'

describe OrderLineItemPageBuilder do
  let(:pages) { double(:create => true) }
  let(:page_decisions) { double(:create => true) }
  let(:line_item) { double('line_item', :requires_a_unique_page? => true, :product_collection_id => 123, :chippd_product_type_id => 123, :page_template_id => 456) }
  let(:customer) { double('customer', :pages => pages, :page_decisions => page_decisions, :has_matching_page? => true) }
  let(:page_line_item) { double('page line item') }

  before do
    PageLineItem.stub(:from_order_line_item).and_return(page_line_item)
    Page.stub(:find_and_update_codes_by_order_line_item).and_return(true)
  end

  subject { described_class.call(customer, line_item) }

  describe ".call" do
    it "should check if the customer has a page available matching the line item" do
      customer.should_receive(:has_matching_page?).with(line_item.product_collection_id, line_item.chippd_product_type_id, line_item.page_template_id)
      subject
    end

    context "when the customer has page available for the line item's chipp'd product type" do
      let(:line_items) { double('line items', :<< => true) }
      let(:page) { double('page', :save => true, :line_items => line_items) }

      context "when an existing page is passed in" do
        subject { described_class.call(customer, line_item, page) }

        it "should append the line item to the existing page" do
          line_items.should_receive(:<<).with(page_line_item)
          subject
        end

        it "should save the existing page" do
          page.should_receive(:save)
          subject
        end
      end

      context "when an existing page is not passed in" do
        it "should create a new page decision for the customer" do
          page_decisions.should_receive(:create).with(:product_collection_id => line_item.product_collection_id, :chippd_product_type_id => line_item.chippd_product_type_id, :page_template_id => line_item.page_template_id, :line_item => PageLineItem.from_order_line_item(line_item))
          subject
        end
      end
    end

    context "when the customer doesn't have a page available for the line item's chipp'd product type" do
      let(:customer) { double('customer', :pages => pages, :page_decisions => page_decisions, :has_matching_page? => false) }

      it "should create a new page for the customer" do
        pages.should_receive(:create).with(:product_collection_id => line_item.product_collection_id, :chippd_product_type_id => line_item.chippd_product_type_id, :page_template_id => line_item.page_template_id, :line_items => [PageLineItem.from_order_line_item(line_item)])
        subject
      end
    end

    it "should find and update codes based on the order line item" do
      Page.should_receive(:find_and_update_codes_by_order_line_item).and_return(true)
      subject
    end
  end
end
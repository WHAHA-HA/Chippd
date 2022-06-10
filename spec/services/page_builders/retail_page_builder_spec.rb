require 'spec_helper'

describe RetailPageBuilder do
  let(:pages) { double(:create => true) }
  let(:page_decisions) { double(:create => true) }
  let(:customer) { double('customer', :pages => pages, :page_decisions => page_decisions, :has_matching_page? => true) }
  let(:product) { double('product', :product_collection_id => 1, :page_template_id => 1) }
  let(:code) { double('code', :redeem => 1, :to_param => 1, :value => 1, :product => product) }
  let(:chippd_product_type) { double('chippd product type', :to_param => 1) }
  let(:page_line_item) { double('page line item') }

  before do
    Customer.stub(:find).and_return(customer)
    Code.stub(:find).and_return(code)
    ChippdProductType.stub(:find).and_return(chippd_product_type)
    PageLineItem.stub(:from_retail_purchase).and_return(page_line_item)
  end

  subject { described_class.call(customer.to_param, code.to_param, chippd_product_type.to_param) }

  describe ".call" do
    it "should look up the customer based on the value passed in" do
      Customer.should_receive(:find).with(customer.to_param).and_return(customer)
      subject
    end

    it "should look up the code based on the id passed in" do
      Code.should_receive(:find).with(code.to_param).and_return(code)
      subject
    end

    it "should look up the chippd product type based on the value passed in" do
      ChippdProductType.should_receive(:find).with(chippd_product_type.to_param).and_return(chippd_product_type)
      subject
    end

    it "should check if the customer has a page available matching the product" do
      customer.should_receive(:has_matching_page?).with(product.product_collection_id, chippd_product_type.to_param, product.page_template_id)
      subject
    end

    context "when the customer has page available for the chipp'd product type" do
      it "should queue a page decision for the customer" do
        page_decisions.should_receive(:create).with(:product_collection_id => product.product_collection_id, :chippd_product_type => chippd_product_type, :page_template_id => product.page_template_id, :line_item => page_line_item)
        subject
      end
    end

    context "when the customer doesn't have a page available for the chipp'd product type" do
      let(:customer) { double('customer', :pages => pages, :page_decisions => page_decisions, :has_matching_page? => false) }

      it "should create a new page for the customer" do
        pages.should_receive(:create).with(:product_collection_id => product.product_collection_id, :chippd_product_type => chippd_product_type, :page_template_id => product.page_template_id, :line_items => [page_line_item])
        subject
      end
    end
  end
end
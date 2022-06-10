require 'spec_helper'

describe Product do
  it { should be_mongoid_document }
  it { should be_timestamped_document }
  it { should have_visibility }
  it { should be_sortable }

  it { should belong_to(:product_collection) }
  it { should belong_to(:page_template) }
  it { should have_and_belong_to_many(:chippd_product_types) }
  it { should embed_many(:images).of_type(ProductImage) }
  it { should embed_many(:details).of_type(ProductDetail) }

  it { should have_field(:name).of_type(String) }
  it { should have_field(:description).of_type(String) }
  it { should have_field(:price_in_cents).of_type(Integer).with_default_value_of(0) }
  it { should have_field(:preorder).of_type(Boolean).with_default_value_of(false) }
  it { should have_field(:sold_out).of_type(Boolean).with_default_value_of(false) }
  it { should have_field(:contact_for_purchase).of_type(Boolean).with_default_value_of(false) }
  it { should have_field(:greeting_card).of_type(Boolean).with_default_value_of(false) }

  [:name, :description].each do |attr|
    it { should validate_presence_of(attr) }
  end
  it { should validate_numericality_of(:price_in_cents) }

  describe "#default_image" do
    context "when there are no images" do
      subject { Product.new.default_image }
      it { should be_nil }
    end

    context "when there are images" do
      let(:product) { FactoryGirl.create(:product_with_images) }
      subject { product.default_image }
      it { should == product.images.first }
    end
  end

  describe "#price" do
    subject { Product.new.price }
    it { should be_a(Money) }
  end

  describe "#price=" do
    let(:product) { Product.new(:price => 12.99)}

    describe "change of #price_in_cents" do
      subject { product.price_in_cents }
      it { should == 1299 }
    end
  end

  describe "#default_chippd_product_type" do
    context "when there are images" do
      let(:product) { FactoryGirl.create(:product) }
      subject { product.default_chippd_product_type }
      it { should == product.chippd_product_types.first }
    end
  end
end
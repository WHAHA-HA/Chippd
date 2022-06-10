require 'spec_helper'

describe ProductCollection do
  let(:product_collection) { FactoryGirl.create(:product_collection) }

  it { should be_mongoid_document }
  it { should be_timestamped_document }
  it { should have_visibility }
  it { should be_sortable }

  it { should have_field(:name).of_type(String) }
  it { should have_field(:filter_text).of_type(String) }
  it { should have_field(:long_description).of_type(String) }
  it { should have_field(:sample_url).of_type(String).with_default_value_of('/store') }

  it "should have a default collection_url" do
    assert_equal "/store/#{product_collection.id.to_s}/products", product_collection.collection_url
  end 

  it { should have_field(:image_uid).of_type(String) }
  it { should have_field(:inverse_image_uid).of_type(String) }
  it { should have_field(:how_it_works_image_uid).of_type(String) }

  [:name, :long_description, :filter_text, :sample_url, :collection_url].each do |attr|
    it { should validate_presence_of(attr) }
  end

  describe "#to_s" do
    subject { product_collection.to_s }
    it { should == product_collection.name }
  end
end

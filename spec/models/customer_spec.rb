require 'spec_helper'

describe Customer do
  it { should be_mongoid_document }
  it { should be_timestamped_document }

  it { should have_many(:orders).with_dependent(:destroy) }
  it { should have_many(:pages).with_dependent(:destroy) }
  it { should have_many(:memberships).with_dependent(:destroy) }
  it { should embed_many(:page_decisions) }

  it { should have_field(:first_name).of_type(String) }
  it { should have_field(:last_name).of_type(String) }
  it { should have_field(:stripe_id).of_type(String) }

  it { should validate_presence_of(:first_name) }

  describe "name validation" do
    let(:customer) { FactoryGirl.build(:customer) }

    context "when a name is required" do
      before { customer.v1_api! }

      it "fails validation without a name" do
        expect(customer).to have(1).errors_on(:name)
      end
    end

    context "when a name is not required" do
      it "passes validation without a name" do
        expect(customer).to have(0).errors_on(:name)
      end
    end
  end

  describe "last_name validation" do
    let(:customer) { FactoryGirl.build(:customer, :last_name => nil) }

    context "when a last_name is required" do
      before { customer.v1_api! }

      it "passes validation without a last_name" do
        expect(customer).to have(0).errors_on(:last_name)
      end
    end

    context "when a last_name is not required" do
      it "fails validation without a last_name" do
        expect(customer).to have(1).errors_on(:last_name)
      end
    end
  end

  describe "#full_name" do
    let(:customer) { FactoryGirl.build(:customer, :first_name => 'PJ', :last_name => 'Kelly') }

    context "when first_name and last_name are set" do
      it "returns both attributes concatenanted into a string" do
        expect(customer.full_name).to eq('PJ Kelly')
      end
    end

    context "when only first_name is set" do
      let(:customer) { FactoryGirl.build(:customer, :first_name => 'PJ', :last_name => nil) }

      it "returns just the first_name" do
        expect(customer.full_name).to eq('PJ')
      end
    end
  end

  describe "auto-setting of first_name and last_name via name" do
    context "when name is a multi-word string" do
      let(:customer) { FactoryGirl.create(:customer, :name => 'PJ Kelly Esq.') }

      it "sets first_name to the text preceding the first space" do
        expect(customer.first_name).to eq('PJ')
      end

      it "sets last_name to the text following the first space" do
        expect(customer.last_name).to eq('Kelly Esq.')
      end
    end

    context "when name is a single word" do
      let(:customer) { FactoryGirl.build(:customer, :name => 'PJ') }

      before do
        customer.v1_api!
        customer.valid?
      end

      it "sets first_name to the word" do
        expect(customer.first_name).to eq('PJ')
      end

      it "leaves last_name nil" do
        expect(customer.last_name).to be_nil
      end
    end
  end
end

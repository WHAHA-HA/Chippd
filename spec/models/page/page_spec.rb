require 'spec_helper'

describe Page do
  let(:page) { FactoryGirl.create(:page) }

  it { should be_mongoid_document }
  it { should be_timestamped_document }

  it { should belong_to(:page_template) }
  it { should belong_to(:product_collection) }
  it { should belong_to(:chippd_product_type) }
  it { should belong_to(:customer) }

  it { should have_many(:memberships) }

  it { should embed_many(:line_items).of_type(PageLineItem) }
  it { should embed_many(:sections).of_type(PageSection) }

  it { should have_field(:name).of_type(String) }
  it { should have_field(:heading).of_type(String) }
  it { should have_field(:subheading).of_type(String) }
  it { should have_field(:member_ids).of_type(Array).with_default_value_of([]) }
  it { should have_field(:notification_last_sent_at).of_type(DateTime) }
  it { should have_field(:b2b_enabled).of_type(Boolean).with_default_value_of(false) }
  it { should have_field(:estimated_monthly_cost_per_user_in_cents).of_type(Integer).with_default_value_of(0) }
  it { should have_field(:monthly_cost_currency).of_type(String).with_default_value_of('$') }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:monthly_cost_currency) }
  it { should validate_presence_of(:estimated_monthly_cost_per_user) }
  it { should validate_numericality_of(:estimated_monthly_cost_per_user).greater_than_or_equal_to(0) }

  describe "automatic assigning of name" do
    context "when name is not passed in" do
      subject { page.name }
      it { should == "#{page.customer_name}'s Page ##{page.page_number}" }
    end

    context "when name is passed in" do
      let(:page) { FactoryGirl.create(:page, :name => "Awesome Page") }
      subject { page.name }
      it { should == "Awesome Page" }
    end
  end

  describe "#estimated_monthly_cost_per_user" do
    subject { Page.new.estimated_monthly_cost_per_user }
    it { should be_a(Money) }
  end

  describe "#estimated_monthly_cost_per_user=" do
    let(:page) { Page.new(:estimated_monthly_cost_per_user => 12.99)}

    describe "change of #estimated_monthly_cost_per_user_in_cents" do
      subject { page.estimated_monthly_cost_per_user_in_cents }
      it { should == 1299 }
    end
  end

  describe "#estimated_monthly_cost" do
    subject { page.estimated_monthly_cost }

    context "when there are no visitors" do
      before do 
        page.stub(:unique_visitors).and_return(0)
      end
      
      it { should be_zero }
    end

    context "when there are visitors" do
      let(:page) { FactoryGirl.create(:page, :estimated_monthly_cost_per_user => 5) }
      let(:customer_1) { FactoryGirl.create(:customer) }
      let(:customer_2) { FactoryGirl.create(:customer) }

      before do
        page
        customer_1
        customer_2
        page.stub(:unique_visitors).and_return(2)
      end
      it { should eq(Money.new(1000)) }
    end
  end
  
  describe "changing the page_template" do
    it "should not be allowed if the page has sections" do
      page = Factory.create(:page)
      page.page_template_id = 5
      sections = double(:exists? => true, :validated? => true)
      page.stub(:sections).and_return(sections)
      page.valid?.should be_false
      page.errors.include?(:page_template_id).should be_true
    end
    
    it "should succeed if the page doesn't have sections" do
      page = Factory.create(:page)
      page.page_template_id = 5
      sections = double(:exists? => false, :validated? => true)
      page.stub(:sections).and_return(sections)
      page.valid?.should be_true
    end
  end
end


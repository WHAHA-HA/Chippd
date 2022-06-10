require 'spec_helper'

describe Batch do
  it { should be_mongoid_document }
  it { should have_many(:codes) }
  it { should belong_to(:product) }

  it { should have_field(:file_uid).of_type(String) }
  it { should have_field(:code_count).of_type(Integer).with_default_value_of(1) }
  it { should have_field(:retail).of_type(Boolean).with_default_value_of(false) }

  it { should validate_presence_of(:code_count) }
  it { should validate_numericality_of(:code_count).to_allow(:only_integer => true, :greater_than_or_equal_to => 1) }

  it "should require a product if the batch is for retail" do
    batch = Batch.new(:retail => true)
    batch.valid?
    batch.should have(1).errors_on(:product_id)
  end
end
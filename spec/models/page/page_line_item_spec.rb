require 'spec_helper'

describe PageLineItem do
  it { should be_mongoid_document }

  it { should belong_to(:order) }
  it { should belong_to(:product) }
  it { should be_embedded_in(:page) }

  it { should have_field(:line_item_id).of_type(String) }
  it { should have_field(:product_name).of_type(String) }
  it { should have_field(:quantity).of_type(Integer) }
  it { should have_field(:options).of_type(Array) }
  it { should have_field(:code).of_type(String) }
  it { should have_field(:purchased_at).of_type(DateTime) }
end

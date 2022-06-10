require 'spec_helper'

describe PageDecision do
  it { should be_mongoid_document }

  it { should belong_to(:page_template) }
  it { should belong_to(:product_collection) }
  it { should belong_to(:chippd_product_type) }

  it { should embed_one(:line_item) }
  it { should be_embedded_in(:customer) }

  it { should have_field(:settled).of_type(Boolean).with_default_value_of(false) }
end

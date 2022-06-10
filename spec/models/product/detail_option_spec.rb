require 'spec_helper'

describe DetailOption do
  it { should be_mongoid_document }
  it { should be_sortable }

  it { should be_embedded_in(:product_detail).as_inverse_of(:options) }

  it { should have_field(:name).of_type(String) }

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
end

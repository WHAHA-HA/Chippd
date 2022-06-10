require 'spec_helper'

describe ProductDetail do
  it { should be_mongoid_document }
  it { should be_sortable }

  it { should be_embedded_in(:product).as_inverse_of(:details) }
  it { should embed_many(:options).of_type(DetailOption) }

  it { should have_field(:name).of_type(String) }

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
end

require 'spec_helper'

describe ProductImage do
  it { should be_mongoid_document }
  it { should have_visibility }
  it { should be_sortable }

  it { should be_embedded_in(:product).as_inverse_of(:images) }

  it { should have_field(:image_uid).of_type(String) }
  it { should have_field(:caption).of_type(String) }

  [:caption, :image].each do |attr|
    it { should validate_presence_of(attr) }
  end
end
require 'spec_helper'

describe ContentLocation do
  it { should be_mongoid_document }

  it { should be_embedded_in(:content) }

  it { should have_field(:name).of_type(String) }
  it { should have_field(:path).of_type(String) }

  [:name, :path].each do |attr|
    it { should validate_presence_of(attr) }
  end
end

require 'spec_helper'

describe Content do
  it { should be_mongoid_document }
  it { should be_timestamped_document }
  it { should be_sluggable }

  it { should embed_many(:content_locations) }

  it { should have_field(:name).of_type(String) }
  it { should have_field(:body).of_type(String) }

  [:name, :body].each do |attr|
    it { should validate_presence_of(attr) }
  end
end

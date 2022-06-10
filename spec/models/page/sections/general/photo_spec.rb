require 'spec_helper'

describe Photo do
  it { should be_a(PageSection) }

  it { should have_field(:original_uid).of_type(String) }
  it { should have_field(:image_uid).of_type(String) }
  it { should have_field(:caption).of_type(String) }

  it { should validate_presence_of(:caption) }

  describe "#storage_used" do
    let(:photo) { Photo.new(:original_size => 1, :image_size => 2) }
    subject { photo.storage_used }
    it { should be(1) }
  end
end
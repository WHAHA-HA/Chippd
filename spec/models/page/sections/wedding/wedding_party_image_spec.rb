require 'spec_helper'

describe WeddingPartyImage do
  it { should be_mongoid_document }
  it { should be_timestamped_document }
  it { should be_sortable }

  it { should be_embedded_in(:wedding_party) }

  it { should have_image_attachment_fields(:original, :image) }
  it { should have_field(:image_type).of_type(String) }
  it { should have_field(:name).of_type(String) }
  it { should have_field(:title).of_type(String) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:title) }

  describe "#storage_used" do
    let(:image) { WeddingPartyImage.new(:original_size => 1, :image_size => 2) }
    subject { image.storage_used }
    it { should be(1) }
  end
end

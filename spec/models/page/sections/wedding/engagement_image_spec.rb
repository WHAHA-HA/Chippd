require 'spec_helper'

describe EngagementImage do
  it { should be_mongoid_document }
  it { should be_timestamped_document }

  it { should be_embedded_in(:engagement) }

  it { should have_image_attachment_fields(:original, :image, :thumb) }

  describe "#storage_used" do
    let(:engagement_image) { EngagementImage.new(:original_size => 1, :image_size => 2, :thumb_size => 3) }
    subject { engagement_image.storage_used }
    it { should be(1) }
  end
end

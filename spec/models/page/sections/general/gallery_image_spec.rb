require 'spec_helper'

describe GalleryImage do
  it { should be_mongoid_document }
  it { should be_timestamped_document }

  it { should be_embedded_in(:gallery) }

  it { should have_field(:caption).of_type(String) }
  it { should have_image_attachment_fields(:original, :image, :thumb) }

  describe "#storage_used" do
    let(:gallery_image) { GalleryImage.new(:original_size => 1, :image_size => 2, :thumb_size => 3) }
    subject { gallery_image.storage_used }
    it { should be(1) }
  end
end

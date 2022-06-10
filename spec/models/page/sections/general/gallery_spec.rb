require 'spec_helper'

describe Gallery do
  it { should be_a(PageSectionWithAttachments) }

  it { should embed_many(:gallery_images) }
  it { should have_field(:title).of_type(String) }

  it { should validate_presence_of(:title) }

  describe "#storage_used" do
    let(:gallery) { Gallery.new(:gallery_images => [GalleryImage.new(:original_size => 10, :image_size => 20, :thumb_size => 30)]) }

    it "should calculate storage used based on *_size attributes " do
      expect {
        gallery.gallery_images << GalleryImage.new(:original_size => 20, :image_size => 30, :thumb_size => 40)
      }.to change { gallery.storage_used }.from(10).to(30)
    end
  end
end
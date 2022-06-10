require 'spec_helper'

describe BabysFirst do
  it { should be_a(PageSectionWithAttachments) }
  it { should embed_many(:versions) }
  it { should have_field(:media_type).of_type(String) }
  it { should have_field(:job_id).of_type(String) }
  it { should have_field(:caption).of_type(String) }
  it { should have_image_attachment_fields(:original, :image, :poster) }

  describe "#storage_used for photo" do
    let(:babys_first) { BabysFirst.new(:original_size => 1, :image_size => 2, :media_type => 'photo') }
    subject { babys_first.storage_used }
    it { should be(1) }
  end

  describe "#storage_used for video" do
    let(:babys_first) { BabysFirst.new(:original_size => 1, :image_size => 2, :poster_size => 3, :media_type => 'video') }
    subject { babys_first.storage_used }
    it { should be(4) }
  end

end

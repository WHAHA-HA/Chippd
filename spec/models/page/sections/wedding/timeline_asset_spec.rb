require 'spec_helper'

describe TimelineAsset do
  it { should be_mongoid_document }
  it { should be_timestamped_document }
  it { should be_sortable }

  it { should be_embedded_in(:timeline) }

  it { should have_field(:media_type).of_type(String) }
  it { should have_field(:job_id).of_type(String) }
  it { should have_field(:timeframe).of_type(String) }
  it { should have_field(:heading).of_type(String) }
  it { should have_field(:description).of_type(String) }
  it { should have_field(:track_name).of_type(String) }
  it { should have_attachment_fields(:audio_file) }
  it { should have_image_attachment_fields(:original, :image, :poster) }

  it { should validate_presence_of(:timeframe) }
  it { should validate_presence_of(:heading) }
  it { should validate_presence_of(:description) }

  describe "#storage_used for photo or audio" do
    let(:asset) { TimelineAsset.new(:original_size => 1, :image_size => 2, :media_type => 'photo') }
    subject { asset.storage_used }
    it { should be(1) }
  end

  describe "#storage_used for video" do
    let(:asset) { TimelineAsset.new(:original_size => 1, :image_size => 2, :poster_size => 3, :media_type => 'video') }
    subject { asset.storage_used }
    it { should be(4) }
  end
end

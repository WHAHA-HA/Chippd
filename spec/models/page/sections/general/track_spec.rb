require 'spec_helper'

describe Track do
  it { should be_mongoid_document }
  it { should be_timestamped_document }

  it { should be_embedded_in(:playlist) }

  it { should have_transcoding_fields }
  it { should have_attachment_fields(:file) }

  describe "#storage_used" do
    let(:track) { Track.new(:file_size => 100) }

    it "should calculate storage used based on *_size attributes " do
      expect {
        track.file_size = 150
      }.to change { track.storage_used }.from(100).to(150)
    end
  end
end

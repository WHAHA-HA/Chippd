require 'spec_helper'

describe Playlist do
  it { should be_a(PageSectionWithAttachments) }

  it { should embed_many(:tracks) }
  it { should have_field(:title).of_type(String) }

  describe "#storage_used" do
    let(:playlist) { Playlist.new(:tracks => [Track.new(:file_size => 10)]) }

    it "should calculate storage used based on *_size attributes " do
      expect {
        playlist.tracks << Track.new(:file_size => 20)
      }.to change { playlist.storage_used }.from(10).to(30)
    end
  end
end

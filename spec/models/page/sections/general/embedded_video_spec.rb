require 'spec_helper'

describe EmbeddedVideo do
  it { should be_a(PageSection) }
  it { should have_field(:video_url).of_type(String) }
  it { should have_field(:caption).of_type(String) }

  it { should validate_presence_of(:caption) }
  it { should validate_presence_of(:video_url) }

  describe "source validation" do
    subject { embedded_video }
    context "when the video source is acceptable" do
      let(:embedded_video) { EmbeddedVideo.new(:caption => 'Cool video', :video_url => 'http://www.youtube.com/watch?v=BM9T1oO_umM') }
      it { should be_valid }
    end

    context "when the video source is not acceptable" do
      let(:embedded_video) { EmbeddedVideo.new(:caption => 'Cool video', :video_url => 'http://www.vine.com') }
      it { should_not be_valid }
      it { should have(1).errors_on(:video_url) }
    end
  end

  describe "#video_type" do
    subject { embedded_video.video_type }
    context "when the video url is from YouTube" do
      let(:embedded_video) { EmbeddedVideo.new(:video_url => 'http://www.youtube.com/watch?v=BM9T1oO_umM') }
      it { should be(:youtube) }
    end

    context "when the video url is from YouTube" do
      let(:embedded_video) { EmbeddedVideo.new(:video_url => 'http://www.vimeo.com/watch?v=BM9T1oO_umM') }
      it { should be(:vimeo) }
    end

    context "when the video source is unrecognized" do
      let(:embedded_video) { EmbeddedVideo.new(:video_url => 'http://www.vine.com') }
      it { should be_nil }
    end
  end

  describe "#parsed_video_url" do
    let(:embedded_video) { EmbeddedVideo.new(:video_url => 'http://www.youtube.com/watch?v=BM9T1oO_umM') }
    subject { embedded_video.parsed_video_url }
    it { should be_a(URI) }
  end
end
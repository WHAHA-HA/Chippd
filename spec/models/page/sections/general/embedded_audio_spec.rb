require 'spec_helper'

describe EmbeddedAudio do
  it { should be_a(PageSection) }
  it { should have_field(:audio_url).of_type(String) }
  it { should have_field(:caption).of_type(String) }

  it { should validate_presence_of(:caption) }
  it { should validate_presence_of(:audio_url) }

  describe "source validation" do
    subject { embedded_audio }
    context "when the audio source is acceptable" do
      let(:embedded_audio) { EmbeddedAudio.new(:caption => 'Cool audio', :audio_url => 'https://soundcloud.com/peter-sujith/i-wanna-be-your-supergirl') }
      it { should be_valid }
    end

    context "when the audio source is not acceptable" do
      let(:embedded_audio) { EmbeddedAudio.new(:caption => 'Cool audio', :audio_url => 'http://www.vine.com') }
      it { should_not be_valid }
      it { should have(1).errors_on(:audio_url) }
    end
  end

  describe "#audio_type" do
    subject { embedded_audio.audio_type }
    context "when the audio url is from YouTube" do
      let(:embedded_audio) { EmbeddedAudio.new(:audio_url => 'https://soundcloud.com/peter-sujith/i-wanna-be-your-supergirl') }
      it { should be(:soundcloud) }
    end

    context "when the audio source is unrecognized" do
      let(:embedded_audio) { EmbeddedAudio.new(:audio_url => 'http://www.vine.com') }
      it { should be_nil }
    end
  end

  describe "#parsed_audio_url" do
    let(:embedded_audio) { EmbeddedAudio.new(:audio_url => 'https://soundcloud.com/peter-sujith/i-wanna-be-your-supergirl') }
    subject { embedded_audio.parsed_audio_url }
    it { should be_a(URI) }
  end
end

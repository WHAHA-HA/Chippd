require 'spec_helper'

describe TimelinePostProcessingHandler do

  let(:versions) { double(:create => true) }
  let(:video_asset) { double(:versions => versions, :poster_url= => true) }
  let(:audio_asset) { double(:audio_file_uid => 'blah', :update_attributes! => true) }
  let(:videos) { double(:where => [video_asset], :each => [video_asset]) }
  let(:tracks) { double(:where => [audio_asset], :each => [audio_asset]) }
  let(:section) { double('section', :activate! => true, :error! => true, :error? => false, :timeline_assets => double(:videos => videos, :tracks => tracks)) }
  let(:message) {
    {"state"=>"COMPLETED",
     "input"=>{"key"=>"2014/key/sample.m4v"},
     "outputKeyPrefix"=>"2014/key/"}
  }
  let(:error_message) {
    {"state"=>"ERROR"}
  }

  describe "#handle" do
    context "transcoding completed" do
      subject { described_class.new(section, message).handle }

      it "handles a video" do
        described_class.any_instance.should_receive(:handle_video)
        described_class.any_instance.should_receive(:all_video_assets_processed?).once.and_return(false)
        section.should_not_receive(:activate!)
        subject
      end

      it "handles an audio track" do
        videos.should_receive(:where).and_return []
        described_class.any_instance.should_receive(:handle_audio)
        described_class.any_instance.should_receive(:all_audio_assets_processed?).once.and_return(false)
        section.should_not_receive(:activate!)
        subject
      end

      it 'activates the section and sends notification to client' do
        described_class.any_instance.should_receive(:all_video_assets_processed?).once.and_return(true)
        described_class.any_instance.should_receive(:all_audio_assets_processed?).once.and_return(true)
        section.should_receive(:activate!)
        described_class.any_instance.should_receive(:notify_client)
        subject
      end
    end

    context "transcoding error" do
      subject { described_class.new(section, error_message).handle }

      it 'sets section state to error and sends notification to client' do
        section.should_receive(:error!)
        described_class.any_instance.should_receive(:notify_client).with(false)
        subject
      end

      it 'raises an exception' do
        section.stub(:error!).and_raise(RuntimeError)
        described_class.any_instance.should_receive(:notify_client).with(false)
        expect{ subject }.to raise_error(Chippd::PostProcessingError)
      end
    end
  end

  describe "#handle_video" do
    subject { described_class.new(section, message).handle_video(video_asset) }

    it "sets the poster_url and creates versions" do
      video_asset.should_receive(:poster_url=).with('https://s3.amazonaws.com/chippd-test/2014/key/sample_00001.png')
      video_asset.should_receive(:versions).and_return versions
      versions.should_receive(:create).exactly(4).times
      subject
    end
  end

  describe "#handle_audio" do
    subject { described_class.new(section, message).handle_audio(audio_asset) }

    it "sets the audio_file_uid" do
      audio_asset.should_receive(:update_attributes!).once.with(audio_file_uid: '2014/key/sample.mp3')
      subject
    end
  end

end

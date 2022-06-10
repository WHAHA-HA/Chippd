require 'spec_helper'

describe TimelineUploadHandler do

  let(:asset) { [double(update_attributes!: true, destroy: true)] }
  let(:timeline_assets) { double('timeline_assets', :create! => true, :where => asset, :map => ['1', '2', '3']) }
  let(:section) { double('section', :id => 1, :activate! => true, :original_url= => true, :timeline_assets => timeline_assets) }
  let(:upload_params) {
    {
      upload: [
        {id: '',  url: 'www.create.com', media_type: 'photo'},
        {id: '',  url: 'www.create.com', media_type: 'audio'},
        {id: '',  url: 'www.create.com', media_type: 'video'},
        {id: '1', url: 'www.update_me.com/chippd-uploads-test/', media_type: 'photo'},
        {id: '2', url: 'www.update_me.com/chippd-uploads-test/', media_type: 'audio'},
        {id: '3', url: 'www.update_me.com/chippd-uploads-test/', media_type: 'video'},
        {id: '1', url: '', media_type: 'photo'},
        {id: '2', url: '', media_type: 'audio'},
        {id: '3', url: '', media_type: 'video'}
      ].to_json
    }
  }

  describe "#handle" do
    subject { described_class.new(section, upload_params).handle }

    it "handles photos, tracks and videos without additional processing" do
      described_class.any_instance.should_receive(:handle_photos)
      described_class.any_instance.should_receive(:handle_tracks).and_return(false)
      described_class.any_instance.should_receive(:handle_videos).and_return(false)
      section.should_receive(:activate!)
      described_class.any_instance.should_receive(:notify_client)
      subject
    end

    it "handles photos, tracks and videos with additional processing" do
      described_class.any_instance.should_receive(:handle_photos)
      described_class.any_instance.should_receive(:handle_tracks).and_return(false)
      described_class.any_instance.should_receive(:handle_videos).and_return(true)
      section.should_not_receive(:activate!)
      described_class.any_instance.should_not_receive(:notify_client)
      subject
    end

    it 'raises an exception' do
      described_class.any_instance.stub(:handle_photos).and_raise(RuntimeError)
      described_class.any_instance.should_receive(:notify_client).with(false)
      expect{ subject }.to raise_error(Chippd::UploadProcessingError)
    end
  end

  describe "#handle_photos" do
    subject { described_class.new(section, upload_params).handle_photos }

    it "creates a new photo" do
      section.timeline_assets.should_receive(:create!).with(original_url: 'www.create.com', media_type: 'photo', timeframe: nil, heading: nil, description: nil, track_name: nil, original_size: nil)
      subject
    end

    it "updates a photo" do
      asset.first.should_receive(:update_attributes!).with(original_url: 'www.update_me.com/chippd-uploads-test/', media_type: 'photo', timeframe: nil, heading: nil, description: nil, track_name: nil, original_size: nil)
      section.timeline_assets.should_receive(:where).with(id: '1')
      subject
    end

    it "destroys a photo" do
      asset.first.should_receive(:destroy)
      section.timeline_assets.should_receive(:where).with(id: '1')
      subject
    end
  end

  describe "#handle_tracks" do
    subject { described_class.new(section, upload_params).handle_tracks }

    it "creates a new track" do
      described_class.any_instance.stub(:create_audio_job).and_return double(data: {job: {id: 'job_id'}})
      section.timeline_assets.should_receive(:create!).with(job_id: 'job_id', media_type: 'audio', timeframe: nil, heading: nil, description: nil, track_name: nil, original_size: nil)
      subject
    end

    it "updates a track" do
      described_class.any_instance.stub(:create_audio_job).and_return double(data: {job: {id: 'job_id'}})
      asset.first.should_receive(:update_attributes!).with(job_id: 'job_id', media_type: 'audio', timeframe: nil, heading: nil, description: nil, track_name: nil, original_size: nil)
      section.timeline_assets.should_receive(:where).with(id: '2')
      subject
    end

    it "destroys a video" do
      described_class.any_instance.stub(:create_audio_job).and_return double(data: {job: {id: 'job_id'}})
      asset.first.should_receive(:destroy)
      section.timeline_assets.should_receive(:where).with(id: '2')
      subject
    end
  end

  describe "#handle_videos" do
    subject { described_class.new(section, upload_params).handle_videos }

    it "creates a new video" do
      described_class.any_instance.stub(:create_video_job).and_return double(data: {job: {id: 'job_id'}})
      section.timeline_assets.should_receive(:create!).with(job_id: 'job_id', media_type: 'video', timeframe: nil, heading: nil, description: nil, track_name: nil, original_size: nil)
      subject
    end

    it "updates a video" do
      described_class.any_instance.stub(:create_video_job).and_return double(data: {job: {id: 'job_id'}})
      asset.first.should_receive(:update_attributes!).with(job_id: 'job_id', media_type: 'video', timeframe: nil, heading: nil, description: nil, track_name: nil, original_size: nil)
      section.timeline_assets.should_receive(:where).with(id: '3')
      subject
    end

    it "destroys a video" do
      described_class.any_instance.stub(:create_video_job).and_return double(data: {job: {id: 'job_id'}})
      asset.first.should_receive(:destroy)
      section.timeline_assets.should_receive(:where).with(id: '3')
      subject
    end
  end

end

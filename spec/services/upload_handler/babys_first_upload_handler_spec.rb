require 'spec_helper'

describe BabysFirstUploadHandler do

  let(:section) { double('section', :id             => 1,
                                    :activate!      => true,
                                    :original_size= => true) }
  let(:upload_params) {
    {
      upload_photo: [
        {url: 'www.update_me.com/chippd-uploads-test/photo', media_type: 'photo'}
      ].to_json,
      upload_video: [
        {url: 'www.update_me.com/chippd-uploads-test/video', media_type: 'video'}
      ].to_json
    }
  }

  describe "#handle" do
    subject { described_class.new(section, upload_params).handle }

    it "updates section with a photo" do
      section.stub(:photo? => true)
      section.should_receive(:original_url=).with('www.update_me.com/chippd-uploads-test/photo')
      section.should_receive(:activate!)
      described_class.any_instance.should_receive(:notify_client)
      subject
    end

    it "updates section with a video" do
      section.stub(:photo? => false)
      section.stub(:video? => true)
      described_class.any_instance.stub(:create_video_job).and_return double(data: {job: {id: 'job_id'}})
      section.should_receive(:update_attributes!).with(job_id: 'job_id', original_size: nil)
      subject
    end

    it 'raises an exception' do
      section.stub(:photo? => true)
      described_class.any_instance.stub(:has_upload_photo?).and_raise(RuntimeError)
      described_class.any_instance.should_receive(:notify_client).with(false)
      expect{ subject }.to raise_error(Chippd::UploadProcessingError)
    end
  end

end

require 'spec_helper'

describe VideoUploadHandler do

  let(:section) { double('section', :update_attributes! => true) }
  let(:upload_params) {
    { upload: [{:url => 'www.blah.com/video.m4v', :uploadSize => '1234'}].to_json }
  }

  describe "#handle" do
    subject { described_class.new(section, upload_params).handle }

    before :each do
      @fake_client = double('client', :create_job => double(:data => {:job => {:id => 1}}))
      AWS::ElasticTranscoder::Client.should_receive(:new).and_return @fake_client
    end

    it "sets the job_id from client" do
      section.should_receive(:update_attributes!).with({job_id: 1, original_size: '1234'})
      subject
    end

    it 'has correct job creation params' do
      @fake_client.should_receive(:create_job).with({:pipeline_id=>"FAKE",
                                                     :input=>{:key=>"www.blah.com/video.m4v"},
                                                     :output_key_prefix=>"www.blah.com/",
                                                     :outputs=>[{:key=>"video_adv.mp4", :preset_id=>"1397766036546-dt7vyr", :thumbnail_pattern=>"video_{count}"},
                                                                {:key=>"video_uni.mp4", :preset_id=>"1397765536833-k20mtr", :thumbnail_pattern=>"video_{count}"},
                                                                {:key=>"video.webm", :preset_id=>"1397774863559-peyvo1", :thumbnail_pattern=>"video_{count}"},
                                                                {:key=>"video.hls", :preset_id=>"1351620000001-200030", :thumbnail_pattern=>"video_{count}"}]
                                                    })
      subject
    end

    it 'raises an exception' do
      section.stub(:update_attributes!).and_raise(RuntimeError)
      expect{ subject }.to raise_error(Chippd::UploadProcessingError)
    end
  end

end

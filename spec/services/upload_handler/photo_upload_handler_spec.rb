require 'spec_helper'

describe PhotoUploadHandler do

  let(:customer) { double('customer', :id => 1) }
  let(:section) { double('section', :id => 1, :activate! => true, :original_url= => true) }
  let(:upload_params) {
    { upload: [{:url => 'www.blah.com'}].to_json }
  }

  describe "#handle" do
    subject { described_class.new(section, upload_params).handle }

    it "sets the original_url from params" do
      DeliverPusherEventWorker.stub(:perform_in).and_return(true)
      section.should_receive(:original_url=).with((JSON.parse upload_params[:upload]).first['url'])
      subject
    end

    it 'sends notification to client' do
      DeliverPusherEventWorker.should_receive(:perform_in).with(5.seconds, section.to_param, true)
      subject
    end

    it 'raises an exception' do
      section.stub(:activate!).and_raise(RuntimeError)
      DeliverPusherEventWorker.should_receive(:perform_in).with(5.seconds, section.to_param, false)
      expect{ subject }.to raise_error(Chippd::UploadProcessingError)
    end
  end

end

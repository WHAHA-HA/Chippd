require 'spec_helper'

describe VideoPostProcessingHandler do

  let(:versions) { double(:create => true) }
  let(:section) { double('section', :poster_url= => true, :activate! => true, :error! => true, :versions => versions) }
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

      it "sets the poster_url and creates versions" do
        DeliverPusherEventWorker.stub(:perform_in).and_return(true)
        section.should_receive(:poster_url=).with('https://s3.amazonaws.com/chippd-test/2014/key/sample_00001.png')
        versions.should_receive(:create).exactly(4).times
        section.should_receive(:versions).and_return versions
        subject
      end

      it 'activates the section and sends notification to client' do
        section.should_receive(:activate!)
        DeliverPusherEventWorker.should_receive(:perform_in).with(5.seconds, section.to_param, true)
        subject
      end
    end

    context "transcoding error" do
      subject { described_class.new(section, error_message).handle }

      it 'sets section state to error and sends notification to client' do
        section.should_receive(:error!)
        DeliverPusherEventWorker.should_receive(:perform_in).with(5.seconds, section.to_param, false)
        subject
      end

      it 'raises an exception' do
        section.stub(:error!).and_raise(RuntimeError)
        expect{ subject }.to raise_error(Chippd::PostProcessingError)
      end
    end
  end

end

require 'spec_helper'

describe PlaylistPostProcessingHandler do

  let(:track) { double('track', :file_uid => 'blah', :update_attribute => true) }
  let(:tracks) { double(:where => [track], :each => [track]) }
  let(:section) { double('section', :activate! => true, :error! => true, :error? => false, :tracks => tracks) }
  let(:message) {
    {"state"=>"COMPLETED",
     "input"=>{"key"=>"2014/key/sample.aac"},
     "outputKeyPrefix"=>"2014/key/"}
  }
  let(:error_message) {
    {"state"=>"ERROR"}
  }

  describe "#handle" do
    context "transcoding completed" do
      subject { described_class.new(section, message).handle }

      it "sets the file_uid" do
        DeliverPusherEventWorker.stub(:perform_in).and_return(true)
        track.should_receive(:update_attribute).with(:file_uid, '2014/key/sample.mp3')
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

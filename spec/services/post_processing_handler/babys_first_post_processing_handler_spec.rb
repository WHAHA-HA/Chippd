require 'spec_helper'

describe BabysFirstPostProcessingHandler do

  let(:versions) { double(:create => true) }
  let(:section)  { double('section', :activate! => true, :error! => true, :versions => versions, :poster_url= => true) }
  let(:message)  {
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
        section.should_receive(:poster_url=).with('https://s3.amazonaws.com/chippd-test/2014/key/sample_00001.png')
        section.should_receive(:versions).and_return versions
        versions.should_receive(:create).exactly(4).times
        subject
      end

      it 'activates the section and sends notification to client' do
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

end

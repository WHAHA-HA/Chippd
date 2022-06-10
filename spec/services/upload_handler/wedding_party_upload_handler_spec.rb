require 'spec_helper'

describe WeddingPartyUploadHandler do

  let(:image) { [double(update_attributes!: true, destroy: true)] }
  let(:wedding_party_images) { double('wedding_party_images', :create! => true, :where => image, :map => ['1']) }
  let(:section) { double('section', :id => 1, :activate! => true, :original_url= => true, :wedding_party_images => wedding_party_images) }
  let(:upload_params) {
    {
      upload: [
        {id: '',  url: 'www.create.com'},
        {id: '1', url: 'www.update_me.com/chippd-uploads-test/'},
        {id: '1', url: ''}
      ].to_json
    }
  }

  describe "#handle" do
    subject { described_class.new(section, upload_params).handle }

    it "creates a new wedding_party image" do
      DeliverPusherEventWorker.stub(:perform_in).and_return(true)
      section.wedding_party_images.should_receive(:create!).with(original_url: (JSON.parse upload_params[:upload]).first['url'], name: nil, title: nil, image_type: nil)
      subject
    end

    it "updates a wedding_party image" do
      DeliverPusherEventWorker.stub(:perform_in).and_return(true)
      image.first.should_receive(:update_attributes!).with(original_url: 'www.update_me.com/chippd-uploads-test/', name: nil, title: nil, image_type: nil)
      section.wedding_party_images.should_receive(:where).with(id: '1')
      subject
    end

    it "destroys a wedding_party image" do
      DeliverPusherEventWorker.stub(:perform_in).and_return(true)
      image.first.should_receive(:destroy)
      section.wedding_party_images.should_receive(:where).with(id: '1')
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

require 'spec_helper'

describe GalleryUploadHandler do

  let(:image) { [double(update_attributes!: true, destroy: true)] }
  let(:gallery_images) { double('gallery_images', :create! => true, :where => image, :map => ['1']) }
  let(:section) { double('section', :id => 1, :activate! => true, :original_url= => true, :gallery_images => gallery_images) }
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

    it "creates a new gallery image" do
      DeliverPusherEventWorker.stub(:perform_in).and_return(true)
      section.gallery_images.should_receive(:create!).with(original_url: (JSON.parse upload_params[:upload]).first['url'])
      subject
    end

    it "updates a gallery image" do
      DeliverPusherEventWorker.stub(:perform_in).and_return(true)
      image.first.should_receive(:update_attributes!).with(original_url: 'www.update_me.com/chippd-uploads-test/')
      section.gallery_images.should_receive(:where).with(id: '1')
      subject
    end

    it "destroys a gallery image" do
      DeliverPusherEventWorker.stub(:perform_in).and_return(true)
      image.first.should_receive(:destroy)
      section.gallery_images.should_receive(:where).with(id: '1')
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

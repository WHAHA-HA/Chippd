require 'spec_helper'

describe UpdatePageSection do
  let(:section) { double('section', :save => true, :id => 1, :pend! => true, :update_attributes => true)}
  let(:page) {
    double('page', :sections => double('sections', :find => section), :touch => true, :to_param => 1)
  }
  let(:params) {
    {
      :id => 1,
      :section => {
        :_type => 'Photo'
      },
      :upload => {
        :url => 'www.blah.com'
      }
    }
  }

  describe "#call" do
    subject { described_class.new(page, params).call }

    it "should find the section" do
      page.sections.should_receive(:find).with(params[:id]).and_return(section)
      subject
    end

    it "should update the section" do
      section.should_receive(:update_attributes).with(params[:section])
      subject
    end

    context "when the section is saved" do
      it "should touch the parent page" do
        page.should_receive(:touch)
        subject
      end

      it { should be_true }

      context "when there is upload data" do
        it "should pend the section" do
          section.should_receive(:pend!)
          subject
        end

        it "should queue the UploadWorker" do
          expect {
            subject
          }.to change { UploadWorker.jobs.size }.by(1)
          UploadWorker.jobs.clear
        end
      end

      context "when there is no upload data" do
        let(:params) {
          {
            :section => {
              :_type => 'Photo'
            }
          }
        }

        it "should not queue the UploadWorker" do
          expect {
            subject
          }.to change { UploadWorker.jobs.size }.by(0)
        end
      end
    end

    context "when the section cannot be saved" do
      let(:section) { double('section', :update_attributes => false)}
      it { should be_false }
    end
  end
end

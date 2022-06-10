require 'spec_helper'

describe CreatePageSection do
  let(:policy) { double('policy', :pass? => true) }
  let(:section) { double('section', :save => true, :id => 1, :move_to_top! => true, :pend! => true)}
  let(:page) {
    double('page', :sections => double('sections', :build => section), :touch => true, :to_param => 1)
  }
  let(:params) {
    {
      :section => {
        :_type => 'Photo'
      },
      :upload => {
        :url => 'www.blah.com'
      }
    }
  }

  before do
    PageSectionAvailabilityPolicy.stub(:new).and_return(policy)
  end

  describe "#available?" do
    subject { described_class.new(page, params).available? }

    it "should setup the policy object" do
      PageSectionAvailabilityPolicy.should_receive(:new).with(page, :photo)
      subject
    end

    it "should check if the policy passes" do
      policy.should_receive(:pass?)
      subject
    end

    context "when the policy passes" do
      it { should be_true }
    end

    context "when the policy does not pass" do
      let(:policy) { double('policy', :pass? => false) }
      it { should be_false }
    end
  end

  describe "#call" do
    subject { described_class.new(page, params).call }

    it "should build a new section" do
      page.sections.should_receive(:build).and_return(section)
      subject
    end

    it "should save the section" do
      section.should_receive(:save)
      subject
    end

    context "when the section is saved" do
      it "should move the section to the top" do
        section.should_receive(:move_to_top!)
        subject
      end

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
      let(:section) { double('section', :save => false)}
      it { should be_false }
    end
  end
end

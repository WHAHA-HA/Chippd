require 'spec_helper'

describe Timeline do
  it { should be_a(PageSectionWithAttachments) }
  it { should have_field(:name_one).of_type(String) }
  it { should have_field(:name_two).of_type(String) }
  it { should have_field(:wedding_date).of_type(Date) }

  it { should validate_presence_of(:name_one) }
  it { should validate_presence_of(:name_two) }

  describe "#storage_used" do
    let(:timeline) { Timeline.new(:timeline_assets => [TimelineAsset.new(:original_size => 10, :image_size => 20, :media_type => 'photo')]) }

    it "should calculate storage used based on *_size attributes " do
      expect {
        timeline.timeline_assets << TimelineAsset.new(:original_size => 20, :image_size => 30, :media_type => 'photo')
      }.to change { timeline.storage_used }.from(10).to(30)
    end
  end

end

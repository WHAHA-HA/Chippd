require 'spec_helper'

describe WeddingParty do
  it { should be_a(PageSectionWithAttachments) }

  it { should embed_many(:wedding_party_images) }

  describe "#storage_used" do
    let(:wedding_party) { WeddingParty.new(:wedding_party_images => [WeddingPartyImage.new(:original_size => 10, :image_size => 20)]) }

    it "should calculate storage used based on *_size attributes " do
      expect {
        wedding_party.wedding_party_images << WeddingPartyImage.new(:original_size => 20, :image_size => 30)
      }.to change { wedding_party.storage_used }.from(10).to(30)
    end
  end

end

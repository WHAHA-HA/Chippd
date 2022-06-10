require 'spec_helper'

describe WeddingEvent do
  it { should be_mongoid_document }
  it { should be_timestamped_document }

  it { should be_embedded_in(:wedding_event_widget).as_inverse_of(:events) }

  it { should have_field(:what).of_type(String) }
  it { should have_field(:when).of_type(String) }
  it { should have_field(:happens_on).of_type(Date) }
  it { should have_field(:starts_at).of_type(Time) }
  it { should have_field(:where).of_type(String) }
  it { should have_field(:url).of_type(String) }
  it { should have_field(:note).of_type(String) }
  it { should have_field(:image_uid).of_type(String) }

  describe "#storage_used" do
    let(:wedding_event) { WeddingEvent.new(:original_size => 1, :image_size => 2, :thumb_size => 3) }
    subject { wedding_event.storage_used }
    it { should be(1) }
  end
end

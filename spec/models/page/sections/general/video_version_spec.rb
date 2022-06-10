require 'spec_helper'

describe VideoVersion do
  it { should be_mongoid_document }
  it { should be_timestamped_document }

  it { should be_embedded_in(:video) }
  it { should be_embedded_in(:babys_first) }
  it { should be_embedded_in(:timeline_asset) }

  it { should have_field(:preset).of_type(String) }
  it { should have_field(:codec).of_type(String) }
  it { should have_attachment_fields(:file) }

  describe "#storage_used" do
    let(:video_version) { VideoVersion.new(:file_size => 100) }
    subject { video_version.storage_used }
    it { should be(100) }
  end
end

require 'spec_helper'

describe GenericPdf do
  it { should be_a(PageSectionWithAttachments) }

  it { should have_field(:title).of_type(String) }
  it { should have_attachment_fields(:file) }

  [:title].each do |attr|
    it { should validate_presence_of(attr) }
  end

  describe "#storage_used" do
    let(:pdf) { Pdf.new(:file_size => 100) }
    subject { pdf.storage_used }
    it { should be(100) }
  end
end
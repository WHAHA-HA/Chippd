require 'spec_helper'

describe Link do
  it { should be_a(PageSection) }

  it { should have_field(:title).of_type(String) }
  it { should have_field(:url).of_type(String) }

  [:title, :url].each do |attr|
    it { should validate_presence_of(attr) }
  end

  describe "url validation" do
    subject { Link.new(:url => 'bogusurl') }
    it { should have(1).errors_on(:url) }
  end
end
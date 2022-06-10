require 'spec_helper'

describe LinkToOrDownloadableAsset do
  it { should be_a(PageSection) }

  it { should have_field(:url).of_type(String) }
  it { should have_field(:downloadable).of_type(Boolean).with_default_value_of(false) }
  it { should have_field(:file_uid).of_type(String) }

  [:url, :file].each do |attr|
    it { should validate_presence_of(attr) }
  end
end

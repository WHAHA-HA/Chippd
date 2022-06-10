require 'spec_helper'

describe Video do
  it { should be_a(PageSection) }
  it { should have_transcoding_fields }
  it { should have_field(:caption).of_type(String) }

  it { should validate_presence_of(:caption) }
end

require 'spec_helper'

describe Text do
  it { should be_a(PageSection) }

  it { should have_field(:heading).of_type(String) }
  it { should have_field(:body).of_type(String) }

  it { should validate_presence_of(:heading) }
  it { should validate_presence_of(:body) }
end

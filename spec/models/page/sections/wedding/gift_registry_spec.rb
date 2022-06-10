require 'spec_helper'

describe GiftRegistry do
  it { should be_a(PageSection) }
  it { should have_field(:mail_to_address).of_type(String) }
end

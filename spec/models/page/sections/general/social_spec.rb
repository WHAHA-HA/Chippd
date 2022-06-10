require 'spec_helper'

describe Social do
  it { should be_a(PageSection) }

  Social::NETWORKS.each do |network|
    it { should have_field(:"#{network}_url").of_type(String) }
    it { should validate_format_of(:"#{network}_url").to_allow("https://somewhere.co.uk").not_to_allow("invalid login") }
  end
end
require 'spec_helper'

describe PageSection do
  it { should be_mongoid_document }
  it { should be_timestamped_document }
  it { should have_visibility }
  it { should be_sortable }

  it { should be_embedded_in(:page) }
end

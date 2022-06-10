require 'spec_helper'

describe Faq do
  it { should be_mongoid_document }
  it { should be_timestamped_document }
  it { should have_visibility }
  it { should be_sortable }

  it { should have_field(:question).of_type(String) }
  it { should have_field(:answer).of_type(String) }
end
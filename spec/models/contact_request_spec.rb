require 'spec_helper'

describe ContactRequest do
  it { should be_mongoid_document }
  it { should be_timestamped_document }

  it { should have_field(:email).of_type(String) }
  it { should have_field(:message).of_type(String) }
  it { should have_field(:topic).of_type(String) }
end

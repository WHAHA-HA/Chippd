require 'spec_helper'

describe PressRelease do
  it { should be_mongoid_document }
  it { should be_timestamped_document }
  it { should have_visibility }

  it { should have_field(:title).of_type(String) }
  it { should have_field(:published_on).of_type(Date) }
  it { should have_field(:abstract).of_type(String) }
  it { should have_field(:body).of_type(String) }
  it { should have_field(:original_uid).of_type(String) }

  [:title, :published_on, :abstract, :body, :original].each do |attr|
    it { should validate_presence_of(attr) }
  end
end
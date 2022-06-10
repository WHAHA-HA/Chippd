require 'spec_helper'

describe Locket do
  it { should be_a(PageSection) }

  it { should have_field(:title).of_type(String) }
  it { should have_field(:body).of_type(String) }
  it { should have_field(:image_one_uid).of_type(String) }
  it { should have_field(:image_two_uid).of_type(String) }

  [:title, :body].each do |attr|
    it { should validate_presence_of(attr) }
  end
end
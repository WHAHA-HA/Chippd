require 'spec_helper'

describe Event do
  it { should be_a(PageSection) }

  it { should have_field(:title).of_type(String) }
  it { should have_field(:description).of_type(String) }
  it { should have_field(:happens_on).of_type(Date) }
  it { should have_field(:starts_at).of_type(Time) }
  it { should have_field(:ends_at).of_type(Time) }

  [:title, :description].each do |attr|
    it { should validate_presence_of(attr) }
  end
end
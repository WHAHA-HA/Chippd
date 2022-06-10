require 'spec_helper'

describe SaveTheDate do
  it { should be_a(PageSection) }

  it { should have_field(:your_name).of_type(String) }
  it { should have_field(:fiancee_name).of_type(String) }
  it { should have_field(:happens_on).of_type(Date) }
  it { should have_field(:location).of_type(String) }

  [:your_name, :fiancee_name, :location, :happens_on].each do |attribute|
    it { should validate_presence_of(attribute) }
  end
end

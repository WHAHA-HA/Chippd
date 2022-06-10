require 'spec_helper'

describe Milestone do
  it { should be_mongoid_document }
  it { should be_timestamped_document }

  it { should be_embedded_in(:baby_grows_widget) }

  it { should have_field(:date).of_type(Date) }
  it { should have_field(:age).of_type(String) }
  it { should have_field(:weight).of_type(String) }
  it { should have_field(:height).of_type(String) }

  [:date, :age, :weight, :height].each do |attr|
    it { should validate_presence_of(attr) }
  end

end

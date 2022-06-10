require 'spec_helper'

describe Favorite do
  it { should be_mongoid_document }
  it { should be_timestamped_document }

  it { should be_embedded_in(:babys_favorites_widget) }

  it { should have_field(:category).of_type(String) }
  it { should have_field(:title).of_type(String) }

  [:category, :title].each do |attr|
    it { should validate_presence_of(attr) }
  end

end

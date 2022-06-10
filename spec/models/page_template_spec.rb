require 'spec_helper'

describe PageTemplate do
  it { should be_mongoid_document }
  it { should be_timestamped_document }

  it { should have_many(:products) }
  it { should have_many(:pages) }

  it { should embed_many(:widgets).of_type(PageTemplateWidget) }

  it { should have_field(:name).of_type(String) }
  it { should have_field(:variation).of_type(Symbol).with_default_value_of(:classic) }

  it { should validate_presence_of(:variation) }
  it { should validate_inclusion_of(:variation).to_allow(PageTemplate::VARIATIONS) }
end

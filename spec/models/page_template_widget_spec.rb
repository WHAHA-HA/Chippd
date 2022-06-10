require 'spec_helper'

describe PageTemplateWidget do
  it { should be_mongoid_document }
  it { should be_timestamped_document }
  it { should be_sortable }

  it { should be_embedded_in(:page_template).as_inverse_of(:widgets) }

  it { should have_field(:name).of_type(String) }
  it { should have_field(:description).of_type(String) }
  it { should have_field(:type).of_type(Symbol) }
  it { should have_field(:limit).of_type(Integer) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:type) }
  it { should validate_uniqueness_of(:type) }
  it { should validate_inclusion_of(:type).to_allow(configatron.pages.valid_section_types) }
  it { should validate_numericality_of(:limit).to_allow(:only_integer => true, :nil => true) }
end

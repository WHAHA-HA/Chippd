require 'spec_helper'

describe ChippdProductType do
  it { should be_mongoid_document }
  it { should be_timestamped_document }
  it { should be_sortable }

  it { should have_and_belong_to_many(:products) }
  it { should have_many(:pages) }

  it { should have_field(:name).of_type(String) }
  it { should have_field(:admin_note).of_type(String) }
  it { should have_field(:short_description).of_type(String) }
  it { should have_field(:fixed_quantity).of_type(Integer) }
  it { should have_field(:force_unique_page).of_type(Boolean).with_default_value_of(false) }
  it { should have_field(:privacy).of_type(Symbol).with_default_value_of(:public) }
  it { should have_field(:image_uid).of_type(String) }

  [:name, :short_description].each do |attr|
    it { should validate_presence_of(attr) }
  end
  it { should validate_numericality_of(:fixed_quantity) }
end

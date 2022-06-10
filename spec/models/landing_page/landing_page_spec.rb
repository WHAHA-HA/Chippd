require 'spec_helper'

describe LandingPage do
  it { should be_mongoid_document }
  it { should be_timestamped_document }
  it { should have_visibility }

  it { should embed_many(:images).of_type(LandingPageImage) }
  it { should embed_many(:steps).of_type(LandingPageStep) }

  it { should have_field(:title).of_type(String) }
  it { should have_field(:permalink).of_type(String) }
  it { should have_field(:use_case_url).of_type(String) }
  it { should have_field(:tagline).of_type(String) }
  it { should have_field(:call_to_action).of_type(String) }
  it { should have_field(:next_step_text).of_type(String) }
  it { should have_field(:next_step_url).of_type(String) }
  it { should have_field(:meta_title).of_type(String) }
  it { should have_field(:meta_description).of_type(String) }
  it { should have_field(:meta_keywords).of_type(String) }

  [:title, :permalink, :use_case_url, :tagline, :call_to_action, :next_step_text, :next_step_url, :meta_title, :meta_description, :meta_keywords].each do |attr|
    it { should validate_presence_of(attr) }
  end
  it { should validate_uniqueness_of(:title) }
  it { should validate_uniqueness_of(:permalink) }
  it { should validate_format_of(:permalink).to_allow("weddings-are_fun1234").not_to_allow("-ba?d-permalink") }
  it { should validate_format_of(:use_case_url).to_allow("http://google.com").not_to_allow("not a URL") }
  it { should validate_format_of(:next_step_url).to_allow("http://google.com").not_to_allow("not a URL") }
end

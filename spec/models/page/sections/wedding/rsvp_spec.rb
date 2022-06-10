require 'spec_helper'

describe Rsvp do
  it { should be_a(PageSection) }

  it { should embed_many(:responses).of_type(RsvpResponse) }

  it { should have_field(:heading).of_type(String).with_default_value_of(I18n.t("page.sections.rsvp.defaults.heading")) }
  it { should have_field(:yes_text).of_type(String).with_default_value_of(I18n.t("page.sections.rsvp.defaults.yes_text")) }
  it { should have_field(:no_text).of_type(String).with_default_value_of(I18n.t("page.sections.rsvp.defaults.no_text")) }
  it { should have_field(:meal_options).of_type(Array).with_default_value_of([]) }
  it { should have_field(:respond_by).of_type(Date) }
  it { should have_field(:guests_allowed).of_type(Boolean).with_default_value_of(true) }
  it { should have_field(:maximum_number_of_guests_allowed).of_type(Integer).with_default_value_of(1) }
  it { should have_field(:date_past_message).of_type(String).with_default_value_of(I18n.t("page.sections.rsvp.defaults.date_past_message")) }
  it { should have_field(:thank_you_message).of_type(String).with_default_value_of(I18n.t("page.sections.rsvp.defaults.thank_you_message")) }

  [:heading, :yes_text, :no_text, :respond_by, :thank_you_message].each do |attr|
    it { should validate_presence_of(attr) }
  end

  [:heading, :yes_text, :no_text, :thank_you_message, :date_past_message].each do |attr|
    it { should validate_length_of(attr).with_maximum(configatron.character_limits.rsvp.send(attr)) }
  end


  describe "meal_choices getter/setter methods" do
    let(:array) { %w(Boeuf Poulet Veggie) }
    let(:string) { "Boeuf, Poulet, Veggie" }
    describe "#meal_choices" do
      let(:rsvp) { Rsvp.new(:meal_options => array) }
      it "returns a comma-separated representation of meal_options" do
        expect(rsvp.meal_choices).to eq(string)
      end
    end

    describe "#meal_choices=" do
      let(:rsvp) { Rsvp.new }
      it "sets the meal options array using the string passed in" do
        rsvp.meal_choices = string
        expect(rsvp.meal_options).to eq(array)
      end

      it "deals with screwy input" do
        rsvp.meal_choices = "Beef, Chicken   \n, , YIKES what the heck?"
        expect(rsvp.meal_options).to eq(['Beef', 'Chicken', 'YIKES what the heck?'])
      end
    end
  end

  describe "#maximum_number_of_guests_allowed_including_invitee" do
    let(:rsvp) { Rsvp.new(:maximum_number_of_guests_allowed => 1) }
    subject { rsvp.maximum_number_of_guests_allowed_including_invitee }
    it { should eq(2) }
  end
end

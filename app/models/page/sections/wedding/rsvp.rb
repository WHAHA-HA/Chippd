require 'csv'

class Rsvp < PageSection
  embeds_many :responses, :class_name => 'RsvpResponse' do
    def to_csv
      CSV.generate do |csv|
        csv << ['Name', 'Attending?', 'Meal Choice', 'Responded On']
        all.each do |response|
          response.guests.each do |guest|
            csv << [guest.name, (response.attending ? 'Yes' : 'No'), (guest.meal || 'No meal preference'), response.created_at.stamp(configatron.datetime_formats.default)]
          end
        end
      end
    end
  end

  field :heading, :type => String, :default => I18n.t("page.sections.rsvp.defaults.heading")
  field :yes_text, :type => String, :default => I18n.t("page.sections.rsvp.defaults.yes_text")
  field :no_text, :type => String, :default => I18n.t("page.sections.rsvp.defaults.no_text")
  field :meal_options, :type => Array, :default => []
  field :respond_by, :type => Date
  field :guests_allowed, :type => Boolean, :default => true
  field :maximum_number_of_guests_allowed, :type => Integer, :default => 1
  field :date_past_message, :type => String, :default => I18n.t("page.sections.rsvp.defaults.date_past_message")
  field :thank_you_message, :type => String, :default => I18n.t("page.sections.rsvp.defaults.thank_you_message")

  validates :heading, :presence => true, :length => {
    :maximum => configatron.character_limits.rsvp.heading
  }
  validates :yes_text, :presence => true, :length => {
    :maximum => configatron.character_limits.rsvp.yes_text
  }
  validates :no_text, :presence => true, :length => {
    :maximum => configatron.character_limits.rsvp.no_text
  }
  validates :respond_by, :presence => true
  validates :date_past_message, :presence => true, :length => {
    :maximum => configatron.character_limits.rsvp.date_past_message
  }
  validates :thank_you_message, :presence => true, :length => {
    :maximum => configatron.character_limits.rsvp.thank_you_message
  }

  def meal_choices
    self.meal_options.join(', ')
  end

  def meal_choices=(choices = nil)
    self.meal_options = choices.split(',').collect(&:strip).reject(&:blank?) if choices
  end

  def formatted_respond_by
    self.respond_by ? self.respond_by.stamp('2013-11-30') : ''
  end

  def maximum_number_of_guests_allowed_including_invitee
    maximum_number_of_guests_allowed + 1
  end
end

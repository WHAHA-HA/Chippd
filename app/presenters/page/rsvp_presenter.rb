class RsvpPresenter < PageSectionPresenter
  delegate :heading, :yes_text, :no_text, :responses, :maximum_number_of_guests_allowed_including_invitee, :thank_you_message, :to => :page_section

  def guests_allowed?
    page_section.guests_allowed
  end

  def respond_by
    page_section.respond_by.stamp('December 16th, 2013')
  end

  def meal_options?
    page_section.meal_options.present?
  end

  def meal_options
    page_section.meal_options + ['No Preference']
  end

  def deadline_passed?
    page_section.respond_by < Date.today
  end

  def date_past_message
    markdown(page_section.date_past_message)
  end

  protected

  def sortable_content
    [type.name, page_section.heading, respond_by].join(' - ')
  end
end

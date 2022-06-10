module RsvpHelper

  def rsvp_response_form_path(rsvp, rsvp_response)
    rsvp_response.new_record? ? rsvp_responses_path(rsvp) : rsvp_response_path(rsvp, rsvp_response)
  end

  def first_guest?(guests, guest)
     guests.first == guest
  end

  def last_guest?(guests, guest)
     guests.last == guest
  end

  def guest_count(responses)
    responses.reject(&:new_record?).sum { |r| r.guests.length }
  end
end
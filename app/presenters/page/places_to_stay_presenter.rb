class PlacesToStayPresenter < PageSectionPresenter
  def additional_info?
    page_section.when_booking.present?
  end

  def when_booking
    handle_none(page_section.when_booking) do
      markdown(page_section.when_booking)
    end
  end

  def featured_place?
    page_section.featured_place.present?
  end

  def featured_place
    PlaceToStayPresenter.new(page_section.featured_place, @template)
  end

  def places
    page_section.places.collect { |place| PlaceToStayPresenter.new(place, @template) }
  end
end

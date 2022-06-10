class PlaceToStayPresenter < BasePresenter
  presents :place_to_stay
  delegate :name, :to => :place_to_stay

  def address
    content_tag(:div, :class => 'addy') do
      [street, [city, state].compact.join(', '), postal_code, country].join("\n").html_safe
    end
  end

  def street
    handle_none(place_to_stay.address) do
      content_tag(:div, place_to_stay.address, :class => 'street-address')
    end
  end

  def city
    handle_none(place_to_stay.city) do
      content_tag(:span, place_to_stay.city, :class => 'locality')
    end
  end

  def state
    handle_none(place_to_stay.state) do
      content_tag(:span, place_to_stay.state, :class => 'region')
    end
  end

  def postal_code
    handle_none(place_to_stay.postal_code) do
      content_tag(:span, place_to_stay.postal_code, :class => 'postal-code')
    end
  end

  def country
    handle_none(place_to_stay.country) do
      content_tag(:div, place_to_stay.country, :class => 'country-name')
    end
  end

  def phone
    handle_none(place_to_stay.phone) do
      link_to(place_to_stay.phone, "tel:#{place_to_stay.phone}", :class => 'tel')
    end
  end

  def link
    link_to(base_url, place_to_stay.url)
  end

  def image
    handle_none(place_to_stay.image_uid) do
      image_tag(place_to_stay.image.remote_url, :width => 150)
    end
  end

  def price
    results = []
    (1..4).each do |i|
      results << content_tag(:span, '$', :class => price_class(i))
    end
    results.join("\n").html_safe
  end

  def booking_info
    handle_none(place_to_stay.booking_info) do
      content_tag(:div, place_to_stay.booking_info, :class => '')
    end
  end

  protected

  def base_url
    URI.parse(place_to_stay.url).host
  end

  def price_class(i)
    (place_to_stay.price >= i) ? 'on' : 'off'
  end
end

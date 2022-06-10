class InvitationPresenter < PageSectionPresenter
  delegate :intro, :location_name, :happens_on, :time, :after, :note, :bride_name, :groom_name, :to => :page_section

  def image
    handle_none(page_section.image_uid) do
      image_tag(page_section.image.remote_url, :width => 150)
    end
  end

  def location_address
    markdown(page_section.location_address)
  end

  def formatted_happens_on
    if page_section.happens_on
      day_and_date = page_section.happens_on.stamp('Saturday October 6,')
      year =  page_section.happens_on.stamp('2012')
      %{<span class="date">#{day_and_date}</span> <span class="year">#{year}</span>}.html_safe
    else
      ''
    end
  end

  def formatted_time
    page_section.time ? page_section.time.stamp(configatron.time_formats.twelve_hour) : ''
  end
end

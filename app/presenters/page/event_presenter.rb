class EventPresenter < PageSectionPresenter
  def title
    content_tag(:h1, page_section.title)
  end

  def simple_title
    page_section.title
  end

  def description
    content_tag(:div, markdown(page_section.description), :class => 'desc')
  end

  def simple_description
    page_section.description
  end

  def location
    handle_none(page_section.location) do
      @template.content_tag(:div, :class => "location", 'data-icon' => '@', 'aria-hidden' => 'true') do
        if page_section.url.present?
          @template.concat(link_to(page_section.location, page_section.url))
        else
          @template.concat(page_section.location)
        end
      end
    end
  end

  def datetime
    @template.content_tag(:div, :class => "datetime") do
      @template.concat(time)
    end
  end

  def start_time
    str = [page_section.happens_on.stamp(configatron.date_formats.long)]
    str << page_section.starts_at.stamp(configatron.time_formats.twelve_hour) if start_time?
    parsed_time(str.join(' '))
  end

  def end_time
    str = []
    str << page_section.ends_on.stamp(configatron.date_formats.long) if end_date?
    str << page_section.happens_on.stamp(configatron.date_formats.long) if !end_date? && end_time?
    str << page_section.ends_at.stamp(configatron.time_formats.twelve_hour) if end_time?
    parsed_time(str.join(' '))
  end

  def machine_datetime(time, kind = :start)
    format_string = []
    format_string << '11/30/2014'
    format_string << '11:38:46 PM' if send("#{kind}_time?")
    time.stamp(format_string.join(' '))
  end

  def ends?
    end_date? || end_time?
  end

  def end_time?
    page_section.ends_at.present?
  end

  def start_time?
    page_section.starts_at.present?
  end

  protected

  def time
    @template.content_tag(:span, :class => 'time') do
      @template.concat(@template.content_tag(:time, human_datetime(start_time, :start), :datetime => atom_datetime(start_time), 'aria-hidden' => 'true', 'data-icon' => 't'))
      if end_date? || end_time?
        @template.concat(' - ')
        @template.concat(@template.content_tag(:time, human_datetime(end_time, :end), :datetime => atom_datetime(end_time)))
      end
    end
  end

  def start_date?
    true
  end

  def parsed_time(str = '')
    Time.parse(str) if str.present?
  end

  def end_date?
    page_section.ends_on.present?
  end

  def sortable_content
    page_section.title
  end

  def human_datetime(time, kind = :start)
    format_string = []
    format_string << 'Oct. 5, 2012' if send("#{kind}_date?")
    format_string << '2:39pm' if send("#{kind}_time?")
    time.stamp(format_string.join(' @ '))
  end

  def atom_datetime(time)
    time.to_datetime.rfc3339
  end
end

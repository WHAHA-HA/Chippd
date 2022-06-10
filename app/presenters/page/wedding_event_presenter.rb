class WeddingEventPresenter < BasePresenter
  presents :wedding_event
  delegate :what, :when, :happens_on, :starts_at, :where, :to => :wedding_event

  def url
    handle_none(wedding_event.url) do
      content_tag(:span, link_to(wedding_event.url, wedding_event.url))
    end
  end

  def note
    handle_none(wedding_event.note) do
      content_tag(:span, wedding_event.note)
    end
  end

  def image
    handle_none(wedding_event.image_uid) do
      image_tag(wedding_event.image.remote_url, :width => 150)
    end
  end

  def datetime
    @template.content_tag(:div, :class => "datetime") do
      if wedding_event.happens_on.present?
        @template.concat(formatted_time)
      else
        @template.concat(wedding_event.when)
      end
    end
  end

  def formatted_time
    @template.content_tag(:span, :class => "time") do
      times = []
      times << wedding_event.happens_on.stamp('Oct. 5, 2012')
      if wedding_event.starts_at.present?
        times << wedding_event.starts_at.utc.stamp('2:39pm')
      end
      @template.concat(times.join(' @ '))
    end
  end
end

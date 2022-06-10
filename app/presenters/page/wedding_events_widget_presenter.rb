class WeddingEventsWidgetPresenter < PageSectionPresenter
  def events
    page_section.events.collect { |event| WeddingEventPresenter.new(event, @template) }
  end
end

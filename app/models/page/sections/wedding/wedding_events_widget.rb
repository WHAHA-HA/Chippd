class WeddingEventsWidget < PageSectionWithAttachments
  MINIMUM_NUMBER_OF_EVENTS = 1

  embeds_many :events, :cascade_callbacks => true, :class_name => 'WeddingEvent'

  def storage_used
    events.sum(&:storage_used)
  end

  def events_json
    events.map do |e|
      {
        id: e.id,
        url: e.image.remote_url,
        website: e.url,
        what: e.what,
        when: e.when,
        happens_on: e.happens_on,
        starts_at: e.starts_at,
        where: e.where,
        note: e.note
      }
    end.to_json
  end
end

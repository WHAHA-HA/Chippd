class WeddingEventsWidgetUploadHandler < UploadHandler
  def handle
    upload_params[:upload].each do |upload|
      id, url, other_data = upload['id'], upload['url'], data(upload)

      raise 'Invalid wedding event data.' unless data_valid?(other_data)

      if id.blank? && url
        create(other_data.merge(original_url: url))
      elsif id && url.blank?
        destroy(id)
      elsif modified_url?(id, url)
        update(id, other_data.merge(original_url: url))
      else
        update(id, other_data)
      end
    end
    section.activate!
    notify_client
  rescue => e
    notify_client(false)
    raise_processing_exception!(e)
  end

  private

  def existing
    @existing ||= section.events.map(&:to_param)
  end

  def data(hash)
    {
        what:       hash['what'],
        when:       hash['when'],
        happens_on: hash['happens_on'],
        starts_at:  hash['starts_at'],
        where:      hash['where'],
        url:        hash['website'],
        note:       hash['note']
    }
  end

  def data_valid?(data)
    if data[:what].blank? || data[:happens_on].blank? || data[:where].blank?
      return false
    end
    if data[:url].present? && !(data[:url] =~ URI::regexp(%w(http https)))
      return false
    end
    true
  end

  def event(id)
    section.events.where(id: id).first
  end

  def modified_url?(id, url)
    existing.include?(id) && url.include?(configatron.s3.upload_bucket_name)
  end

  def create(data)
    section.events.create(data)
  end

  def update(id, data)
    event(id).update_attributes!(data)
  end

  def destroy(id)
    event(id).destroy
  end
end

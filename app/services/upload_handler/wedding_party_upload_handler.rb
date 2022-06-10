class WeddingPartyUploadHandler < UploadHandler
  def handle
    upload_params[:upload].each do |upload|
      id, url, other_data = upload['id'], upload['url'], data(upload)

      if id.blank? && url
        create(other_data.merge(original_url: url))
      elsif id && url.blank?
        destroy(id)
      elsif url_modified?(id, url)
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
    @existing ||= section.wedding_party_images.map(&:to_param)
  end

  def data(hash)
    {
      name: hash['name'],
      title: hash['title'],
      image_type: hash['image_type']
    }
  end

  def url_modified?(id, url)
    existing.include?(id) && url.include?(configatron.s3.upload_bucket_name)
  end

  def create(data)
    section.wedding_party_images.create!(data)
  end

  def image(id)
    section.wedding_party_images.where(id: id).first
  end

  def update(id, data)
    image(id).update_attributes!(data)
  end

  def destroy(id)
    image(id).destroy
  end

end

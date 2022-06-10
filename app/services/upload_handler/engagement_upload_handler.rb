class EngagementUploadHandler < UploadHandler
  def handle
    upload_params[:upload].each do |upload|
      id, url = upload['id'], upload['url']

      if id.blank? && url
        create(url)
      elsif id && url.blank?
        destroy(id)
      elsif modified?(id, url)
        update(id, url)
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
    @existing ||= section.engagement_images.map(&:to_param)
  end

  def image(id)
    section.engagement_images.where(id: id).first
  end

  def modified?(id, url)
    existing.include?(id) && url.include?(configatron.s3.upload_bucket_name)
  end

  def create(url)
    section.engagement_images.create!(original_url: url)
  end

  def update(id, url)
    image(id).update_attributes!(original_url: url)
  end

  def destroy(id)
    image(id).destroy
  end

end

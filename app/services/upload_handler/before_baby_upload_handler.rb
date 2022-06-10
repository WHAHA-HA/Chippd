class BeforeBabyUploadHandler < UploadHandler
  def handle
    upload_params[:upload].each do |upload|
      id, url, caption = upload['id'], upload['url'], upload['caption']

      if id.blank? && url
        create(url, caption)
      elsif id && url.blank?
        destroy(id)
      elsif url_modified?(id, url)
        update(id, url)
      end

      if id.present? && url.present? && caption_modified?(id, caption)
        update_caption(id, caption)
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
    @existing ||= section.baby_images.map(&:to_param)
  end

  def url_modified?(id, url)
    existing.include?(id) && url.include?(configatron.s3.upload_bucket_name)
  end

  def caption_modified?(id, caption)
    existing.include?(id) && (image(id).caption != caption)
  end

  def create(url, caption)
    section.baby_images.create(original_url: url, caption: caption)
  end

  def image(id)
    section.baby_images.where(id: id).first
  end

  def update(id, url)
    image(id).update_attributes!(original_url: url)
  end

  def update_caption(id, caption)
    image(id).update_attributes!(caption: caption)
  end

  def destroy(id)
    image(id).destroy
  end

end

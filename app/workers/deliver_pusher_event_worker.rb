class DeliverPusherEventWorker < ProcessingWorker
  def perform(section_id, success)
    section = Page.find_and_return_section(section_id)
    customer = section.page.customer
    if success
      Pusher.trigger("private-#{customer.id}",
                     "image_#{section.to_param}_saved",
                     data(section) )
    else
      Pusher.trigger("private-#{customer.id}",
                     "image_#{section.to_param}_failed",
                     { id: section.to_param })
    end
  end

  private

  def data(section)
    case section._type
    when 'Photo'
      {
        id: section.to_param,
        url: section.image.remote_url,
        caption: section.caption
      }
    when 'Gallery'
      images = section.gallery_images.map do |image|
        {
          original_url: image.original.remote_url,
          thumb_url: image.thumb.remote_url
        }
      end

      {
        id: section.to_param,
        title: section.title,
        images: images
      }
    else
      {
        id: section.to_param
      }
    end
  end

end

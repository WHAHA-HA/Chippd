class EngagementImagePresenter < BasePresenter
  presents :engagement_image

  def link_to_image
    link_to(thumb.html_safe, engagement_image.image.remote_url)
  end

  def show_image
    (engagement_image.image.remote_url)
  end

  def thumb
    image_tag(engagement_image.thumb.remote_url, :alt => "")
  end

  def sortable_content
    image_tag(engagement_image.thumb.remote_url, :alt => "photo", :width => 50)
  end
end

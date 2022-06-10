class BabyImagePresenter < BasePresenter
  presents :baby_image

  def caption
    handle_none(baby_image.caption) do
      content_tag(:figcaption, baby_image.caption)
    end
  end

  def image
    image_tag(baby_image.image.remote_url, :width => 585, :height => 404, :alt => "Baby Photo")
  end

  protected

  def sortable_content
    baby_image.caption? ? baby_image.caption : 'Baby Photo'
  end

end

class LandingPageImagePresenter < BasePresenter
  presents :landing_page_image

  def to_li
    content_tag(:li) do
      concat(content_tag(:div, image_tag(landing_page_image.large.remote_url), :class=> "slide"))
      concat(content_tag(:div, content_tag(:p, landing_page_image.caption), :class=> "overlay"))
    end
  end
end
class LandingPageStepPresenter < BasePresenter
  presents :landing_page_step

  def to_html
    content_tag(:div, :class => 'col4') do
      concat(image_tag(landing_page_step.image.remote_url))
      concat(content_tag(:h4, raw(title)))
      concat(markdown(landing_page_step.description))
    end
  end

  protected

  def title
    "#{content_tag(:i, landing_page_step.number)} #{landing_page_step.title}"
  end
end
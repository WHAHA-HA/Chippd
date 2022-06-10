class LandingPagePresenter < BasePresenter
  presents :landing_page
  delegate :meta_title, :meta_description, :meta_keywords, :to => :landing_page

  def title
    content_tag(:h2, landing_page.title, :class=> 'landing-title')
  end

  def images
    @images ||= landing_page.images.collect { |image| LandingPageImagePresenter.new(image, @template) }
  end

  def link_to_use_case
    link_to(landing_page.use_case_url) do
      concat(content_tag(:p, 'See what you can share'))
      concat(content_tag(:small, '(best viewed on your mobile device)'))
    end
  end

  def steps
    @steps ||= landing_page.steps.collect { |step| LandingPageStepPresenter.new(step, @template) }
  end

  def tagline
    content_tag(:p, landing_page.tagline, :class => 'intro')
  end

  def call_to_action
    content_tag(:p, landing_page.call_to_action, :class => 'outro')
  end

  def link_to_next_step
    link_to(landing_page.next_step_text, landing_page.next_step_url, :class => 'btn link-to-next-step')
  end
end
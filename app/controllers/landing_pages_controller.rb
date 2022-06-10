class LandingPagesController < ApplicationController
  helper_method :page

  def show
    redirect_to root_url unless landing_page?
  end

  protected

  def landing_page
    @landing_page ||= LandingPage.visible.by_permalink(params[:id])
  end

  def landing_page?
    landing_page
  end

  def page
    @page ||= LandingPagePresenter.new(landing_page, view_context)
  end

  def default_meta_tags
    super.merge!({
      :site => page.meta_title,
      :title => nil,
      :description => page.meta_description,
      :keywords => page.meta_keywords
    })
  end
end
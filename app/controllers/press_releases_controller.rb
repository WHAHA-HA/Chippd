class PressReleasesController < ApplicationController
  before_filter :setup_subnav, :only => :index

  def index
    @press_releases = PressReleasePresenter.from_collection(PressRelease.visible, view_context)
  end

  def show
    @press_release = PressReleasePresenter.new(PressRelease.find(params[:id]), view_context)
  end

  protected

  def default_meta_tags
    super.merge!({
      :site => "Chipp'd in the News.",
      :title => "Here's What the Press Have to Say"
    })
  end
end

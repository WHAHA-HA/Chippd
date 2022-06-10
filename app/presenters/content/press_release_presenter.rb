class PressReleasePresenter < BasePresenter
  presents :press_release
  delegate :title, :to => :press_release

  def published_on
    press_release.published_on.stamp('Jan 1, 2012')
  end

  def abstract
    markdown(press_release.abstract)
  end

  def body
    markdown(press_release.body)
  end

  def thumbnail
    image_tag(press_release.thumb.remote_url, :width => 200)
  end

  def image
    image_tag(press_release.image.remote_url, :width => 800)
  end

  def to_param
    press_release.to_param
  end
end
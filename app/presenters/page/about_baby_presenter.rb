class AboutBabyPresenter < PageSectionPresenter
  delegate :name, :birthday?, :weight, :height, :to => :page_section

  def image
    image_tag(page_section.image.remote_url, :width => 585, :height => 404, :alt => "Baby Photo")
  end

  def birthday
    page_section.birthday.stamp('January 30, 2013')
  end

  protected

  def sortable_content
    page_section.name
  end
end

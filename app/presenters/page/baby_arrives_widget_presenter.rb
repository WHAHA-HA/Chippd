class BabyArrivesWidgetPresenter < PageSectionPresenter
  delegate :weight, :height, :hospital, :parents, :first_name, :last_name, :president, :population, :top_artists, :to => :page_section

  def birthday
    page_section.birthday.stamp('January 12, 2014')
  end

  def image
    image_tag(page_section.image.remote_url, :width => 585, :height => 404, :alt => "Baby Photo")
  end

  protected

  def sortable_content
    page_section.first_name
  end
end

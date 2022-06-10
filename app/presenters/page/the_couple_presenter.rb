class TheCouplePresenter < PageSectionPresenter
  delegate :bride_name, :bride_parents, :groom_name, :groom_parents, :to => :page_section

  def bride_bio
    markdown(page_section.bride_bio)
  end

  def groom_bio
    markdown(page_section.groom_bio)
  end

  def bride_image
    handle_none(page_section.bride_image_uid) do
      image_tag(page_section.bride_image.remote_url, :width => 206, :height => 206, :alt => bride_name)
    end
  end

  def groom_image
    handle_none(page_section.groom_image_uid) do
      image_tag(page_section.groom_image.remote_url, :width => 206, :height => 206, :alt => groom_name)
    end
  end
end

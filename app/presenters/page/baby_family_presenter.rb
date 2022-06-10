class BabyFamilyPresenter < PageSectionPresenter
  delegate :mother_name, :father_name, :to => :page_section

  def mother_bio
    markdown(page_section.mother_bio)
  end

  def father_bio
    markdown(page_section.father_bio)
  end

  def mother_image
    handle_none(page_section.mother_image_uid) do
      image_tag(page_section.mother_image.remote_url, :width => 206, :height => 206, :alt => mother_name)
    end
  end

  def father_image
    handle_none(page_section.father_image_uid) do
      image_tag(page_section.father_image.remote_url, :width => 206, :height => 206, :alt => father_name)
    end
  end
end

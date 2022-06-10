class UpdatePageSection < PersistPageSection
  def call
    if update_section
      handle_upload
      touch_page
      true
    else
      false
    end
  end

  protected

  def update_section
    find_section
    section.update_attributes(params[:section])
  end

  def find_section
    @section = page.sections.find(params[:id])
  end
end

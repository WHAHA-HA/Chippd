class CreatePageSection < PersistPageSection
  def available?
    PageSectionAvailabilityPolicy.new(page, section_type.underscore.to_sym).pass?
  end

  def call
    build_section
    if section.save
      handle_upload
      section.move_to_top!
      touch_page
      true
    else
      false
    end
  end

  protected

  def build_section
    @section = page.sections.build(params[:section], section_type.constantize)
  end

  def section_type
    params[:section][:_type]
  end
end

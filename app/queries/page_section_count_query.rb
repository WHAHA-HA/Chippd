class PageSectionCountQuery
  def initialize(page, section_type)
    @page = page
    @section_type = section_type
  end

  def count
    @page.sections.where(:_type => @section_type.to_s.classify).count
  end
end

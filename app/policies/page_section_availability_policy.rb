class PageSectionAvailabilityPolicy
  attr_reader :page, :section_type

  def initialize(page, section_type)
    @page = page
    @section_type = section_type
  end

  def pass?
    call
    count > 0
  end

  def infinite?
    limit.nil?
  end

  def call
    if infinite?
      @count = 1
    else
      @count = limit - PageSectionCountQuery.new(page, section_type).count
    end
  end

  def count
    if @count
      @count
    else
      call
    end
  end

  def limit
    page_template.limit_for_widget_type(section_type)
  end

  protected

  def page_template
    @page_template ||= page.page_template
  end
end

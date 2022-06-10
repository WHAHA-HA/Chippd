class PageTemplateWidgetsEditablePolicy
  attr_reader :page_template

  def self.call(page_template)
    new(page_template).call
  end

  def initialize(page_template)
    @page_template = page_template
  end

  def call
    editable?
  end

  protected

  def editable?
    pages_with_template.empty?
  end

  def pages_with_template
    @pages_with_template ||= Page.in(chippd_product_type_id: chippd_product_types.map(&:id))
  end

  def chippd_product_types
    @chippd_product_types ||= page_template.chippd_product_types
  end
end

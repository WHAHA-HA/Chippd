class PageSectionTypePresenter < BasePresenter

  def initialize(section_type, page, template)
    @section_type = section_type.to_s
    @page = page
    @template = template
  end

  def name
    widget.name
  end

  def description
    handle_none(widget.description) do
      markdown(widget.description)
    end
  end

  def new_path
    available? ? send("new_#{section_type}_for_my_chippd_page_sections_path", page) : '#'
  end

  def icon
    image_tag("my_chippd/icon-#{section_type}.png", :alt => name)
  end

  def quantity_left
    content_tag(:div, limit_text, :class => quantity_class)
  end

  def to_button
    content_tag(:li, :class => button_html_classes, :title => name) do
      concat(link_to_new)
    end
  end


  def link_to_new
    link_to(new_path, 'data-behavior' => (available? ? '' : 'disabled-section-type-link')) do
      concat(content_tag(:h4, name_and_quantity.html_safe))
      concat(icon)
    end
  end

  def button_html_classes
    html_classes = [section_type]
    html_classes << 'disabled' unless available?
    html_classes.join(' ')
  end

  def to_s
    section_type
  end

  def available?
    page_section_availability_policy.pass?
  end

  configatron.pages.valid_section_types.each do |section|
    define_method(:"#{section}?") do
      section == section_type.to_sym
    end
  end

  protected

  def section_type
    @section_type
  end

  def page
    @page
  end

  def widget
    @widget ||= page.widgets.where(:type => section_type.to_sym).first
  end

  def name_and_quantity
    [name_wrap, quantity_left].join
  end

  def name_wrap
    content_tag(:span, name, :class => 'txt')
  end

  def quantity_class
    html_classes = ['qty']
    html_classes << 'infinite' if infinite_quantity?
    html_classes.join(' ')
  end

  def infinite_quantity?
    page_section_availability_policy.infinite?
  end

  def quantity_limit
    page_section_availability_policy.limit
  end

  def limit_text
    if infinite_quantity?
      '&#8734;'.html_safe
    else
      [page_section_availability_policy.count, quantity_limit].join('/')
    end
  end

  def page_section_availability_policy
    @policy ||= PageSectionAvailabilityPolicy.new(page.page, section_type.to_sym)
  end
end

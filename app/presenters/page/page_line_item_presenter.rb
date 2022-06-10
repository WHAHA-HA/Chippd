class PageLineItemPresenter < BasePresenter
  presents :page_line_item
  delegate :product_name, :to => :page_line_item

  def options
    handle_none(page_line_item.options) do
      page_line_item.options.join(' / ')
    end
  end

  def quantity
    "x #{page_line_item.quantity}"
  end

  def purchased_on
    "(purchased on #{page_line_item.purchased_at.stamp('Jan 1, 2012')})"
  end

  def to_param
    page_line_item.to_param
  end

  def to_html
    begin
      image_url = page_line_item.image.square.url
    rescue
      image_url = 'product-placeholder.png'
    end
    raw(%{<a href="#" rel="tooltip" title="#{to_s}">#{image_tag(image_url)}</a>})
  end

  def to_li
    content_tag(:li, to_html)
  end

  def to_s
    "#{product_name} #{options} #{quantity} #{purchased_on}"
  end
end
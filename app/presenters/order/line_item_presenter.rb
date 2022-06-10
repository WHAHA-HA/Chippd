class LineItemPresenter < BasePresenter
  presents :line_item
  delegate :quantity, :to => :line_item

  def name
    "#{line_item.product_collection_name}: #{line_item.product_name} (#{line_item.chippd_product_type_name})"
  end

  def link_to_product
    link_to(self.name, store_product_path(line_item.product_id), :class => 'name')
  end

  def link_to_remove
    link_to('X', store_order_line_item_path(line_item), :method => :delete, :class => 'remove btn btn-mini')
  end

  def options
    content_tag(:span, line_item.options.join(' / '), :class => 'options')
  end

  def price_each
    number_to_currency(line_item.price_each.to_s)
  end

  def price
    number_to_currency(line_item.price.to_s)
  end

  def to_param
    line_item.to_param
  end
end
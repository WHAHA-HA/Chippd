class DiscountTable < AdminTable
  column :name
  column :code do |object, view|
    view.content_tag(:code, object.code)
  end
  column :type do |object, view|
    (object.is_a?(PercentageDiscount) ? 'Percentage' : 'Dollar Amount')
  end
  column :amount do |object, view|
    (object.is_a?(PercentageDiscount) ? "#{object.amount}%" : view.number_to_currency(object.amount.to_s))
  end
end
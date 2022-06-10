class OrderPresenter < BasePresenter
  presents :order
  delegate :billing_address, :shipping_address, :payment_card, :gift_recipient_email, :gift_recipient_message, :billing_same_as_shipping, :is_gift, :state, :to => :order
  delegate :gift_recipient_message, :paid?, :shipped?, :canceled?, :purchased_at, :shipped_at, :canceled_at, :state, :gift_code_redeemed, :number, :to => :order
  delegate :tracking_number, :estimated_delivery_date, :love?, :flock?, :story?,  :to => :order

  def tracking_number?
    order.tracking_number.present?
  end

  def estimated_delivery_date?
    order.estimated_delivery_date.present?
  end

  def state_badge_class
    {
      'paid' => 'info',
      'shipped' => 'success',
      'canceled' => 'error'
    }[order.state]
  end

  def show_gift_recipient_email?
    order.story?
  end

  def gift_code
    content_tag(:code, order.gift_code)
  end

  def link_to_redeem_gift_code
    link_to('Activate your page.', redeem_gift_code_url)
  end

  def redeem_gift_code_url
    my_chippd_redemptions_url(:gift_code => order.gift_code)
  end

  def gift_code_redeemed_by
    if order.gift_code_redeemed
      redeemer = Customer.find(order.gift_code_redeemed_by)
      redeemer.full_name if redeemer
    end
  end

  def line_items
    order.line_items.collect { |li| LineItemPresenter.new(li, @template) }
  end

  def link_to_with_quantity
    content_tag(:p, link_to(raw("View Cart #{content_tag(:span, "| #{number_of_line_items}", :class => 'qt')}"), store_order_path), :class => 't-cart')
  end

  def number_of_line_items
    order.line_items.length
  end

  def formatted_subtotal
    number_to_currency(order.subtotal.to_s)
  end

  def formatted_total
    number_to_currency(order.total.to_s)
  end

  def discount
    has_discount? ? content_tag(:p, discount_string, :class => 'discount') : ''
  end

  def discount_with_link_to_remove
    has_discount? ? content_tag(:p, raw("#{discount_string}<br />#{link_to('[-] Remove discount', store_order_applied_discount_path, :method => :delete, :class => 'remove')}"), :class => 'discount') : ''
  end

  def to_param
    order.to_param
  end

  def discount_string
    "[#{order.applied_discount.name}:] -#{formatted_discount_amount}"
  end

  def formatted_discount_amount
    number_to_currency(order.applied_discount.amount.to_s)
  end

  def has_discount?
    order.applied_discount.present?
  end

  def formatted_sales_tax
    number_to_currency(order.sales_tax.to_s)
  end

  def formatted_shipping_cost
    number_to_currency(order.shipping_cost.to_s)
  end

  def shipping_option
    configatron.shipping.options.find { |o| o.key == order.shipping_option }.name
  end
end
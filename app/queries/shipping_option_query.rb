class ShippingOptionQuery
  attr_reader :order

  def self.call(order)
    new(order).call
  end

  def initialize(order)
    @order = order
  end

  def call
    order.qualifies_for_greeting_card_shipping? ? all_shipping_options : shipping_options_without_greeting_card_shipping
  end

  private

  def all_shipping_options
    configatron.shipping.options
  end

  def shipping_options_without_greeting_card_shipping
    all_shipping_options.reject(&:greeting_card_only?)
  end
end
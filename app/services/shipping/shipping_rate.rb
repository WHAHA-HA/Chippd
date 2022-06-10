# ShippingRate.new(order).rate

class ShippingRate
  def initialize(order)
    @order = order
  end

  def rate
    calculate! if @rate.nil?
    @rate
  end

  protected

  def calculate!
    @rate = rate_class.new(order).calculate!
  end

  def rate_class
    shipping_option.rate_class.constantize
  end

  def shipping_option
    @shipping_option ||= configatron.shipping.options.find { |o| o.key == order.shipping_option }
  end

  def order
    @order
  end
end
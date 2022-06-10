class ShippingCalculator
  def initialize(order)
    @order = order
  end

  def calculate!
    raise Chippd::ImplementInSubclassError
  end

  protected

  def order
    @order
  end
end
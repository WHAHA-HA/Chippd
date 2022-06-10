class SalesTaxCalculator
  attr_reader :order

  def initialize(order)
    @order = order
  end

  def calculate
    Money.new(calculated_sales_tax, configatron.default_currency)
  end

  protected

  def taxable?
    order.shipping_address.state == 'NY'
  end

  def calculated_sales_tax
    taxable? ? (order.subtotal_in_cents * configatron.sales_tax_rate) : 0
  end
end
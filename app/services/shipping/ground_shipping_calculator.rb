class GroundShippingCalculator < ShippingCalculator
  def calculate!
    @rate = Money.new(500, configatron.default_currency)
  end
end
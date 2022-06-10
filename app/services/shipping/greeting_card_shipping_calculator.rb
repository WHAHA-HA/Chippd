class GreetingCardShippingCalculator < ShippingCalculator
  def calculate!
    @rate = Money.new(200, configatron.default_currency)
  end
end
class OvernightShippingCalculator < UpsShippingCalculator

  protected

  def rate_key
    "UPS Next Day Air"
  end
end
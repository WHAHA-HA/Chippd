class UpsShippingCalculator < ShippingCalculator
  include ActiveMerchant::Shipping

  def calculate!
    Money.new(self.rates[rate_key], configatron.default_currency)
  end

  protected

  def rates
    if @rates
      @rates
    else
      @rates = {}
      ups.find_rates(origin, destination, packages).rates.sort_by(&:price).each do |rate|
        @rates[rate.service_name] = rate.price
      end
      @rates
    end
  end

  def shipping_address
    @shipping_address ||= order.shipping_address
  end

  def destination
    @destination ||= Location.new(:country => shipping_address.country, :state => shipping_address.state, :city => shipping_address.city, :postal_code => shipping_address.postal_code)
  end

  def origin
    configatron.shipping.origin
  end

  def packages
    @packages ||= BinPacker.new(order.number_of_units).packages
  end

  def ups
    @ups ||= UPS.new(:login => configatron.shipping.vendors.ups.login, :password => configatron.shipping.vendors.ups.password, :key => configatron.shipping.vendors.ups.access_key, :test => configatron.shipping.test_mode)
  end
end
class Packager
  include ActiveMerchant::Shipping

  def initialize(number_of_units = nil)
    if number_of_units.nil? || number_of_units > 20 || number_of_units.zero?
      raise Chippd::UnpackableQuantityError
    end
    @number_of_units = number_of_units.to_f
  end

  def to_package
    Package.new(total_weight, dimensions, :units => :imperial)
  end

  protected

  def number_of_units
    @number_of_units
  end

  def total_weight
    (number_of_units * weight_per_unit) + box.weight
  end

  def dimensions
    box.dimensions
  end

  def weight_per_unit
    configatron.shipping.weight_per_unit
  end

  def box
    @box ||= configatron.shipping.packaging_options.find { |p| p.unit_max >= number_of_units }
  end
end
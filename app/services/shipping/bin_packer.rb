class BinPacker
  def initialize(number_of_units)
    @total_number_of_units = number_of_units
    @packages = []
  end

  def total_number_of_units
    @total_number_of_units
  end

  def packages
    if @packages.present?
      @packages
    else
      recursively_build_packages_for(total_number_of_units)
      @packages
    end
  end

  protected

  def max_for_largest_box
    configatron.shipping.packaging_options.last.unit_max
  end

  def recursively_build_packages_for(_number_of_units)
    if _number_of_units > max_for_largest_box
      number_of_large_boxes, left_over = _number_of_units.divmod(20)
      number_of_large_boxes.times { @packages << Packager.new(20).to_package }
      recursively_build_packages_for(left_over)
    else
      @packages << Packager.new(_number_of_units).to_package
    end
  end
end
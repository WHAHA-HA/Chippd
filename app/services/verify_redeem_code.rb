class VerifyRedeemCode
  attr_reader :value
  attr_writer :type
  attr_accessor :code

  def self.call(value)
    new(value).call
  end

  def initialize(value)
    @value = value
  end

  def call
    if via_order?
      self.type = :order
    elsif via_retail?
      self.type = :retail
    end
    self
  end

  def type
    ActiveSupport::StringInquirer.new(@type.to_s) if @type.present?
  end

  def pass?
    type.present?
  end

  def redeem_class
    redeem_class_map[type.to_sym]
  end

  def as_json(options = {})
    hash = { :type => type }
    hash[:chippd_product_type_ids] = code.chippd_product_type_ids if type.retail?
    hash
  end

  protected

  def redeem_class_map
    {
      :retail => RedeemRetailCode,
      :order => RedeemGiftCode
    }
  end

  def via_order?
    self.code = OrderByGiftCodeQuery.call(value)
  end

  def via_retail?
    self.code = CodeByRedeemQuery.call(value)
  end
end
class RedeemCode
  attr_reader :customer_id, :code, :chippd_product_id, :verifier

  def self.call(customer_id, code, chippd_product_id = nil)
    new(customer_id, code, chippd_product_id).call
  end

  def initialize(customer_id, code, chippd_product_id = nil)
    @customer_id = customer_id
    @code = code
    @chippd_product_id = chippd_product_id
    @verifier = VerifyRedeemCode.call(code)
  end

  def call
    if verifier.pass?
      verifier.redeem_class.call(customer_id, code, chippd_product_id)
    else
      false
    end
  end
end
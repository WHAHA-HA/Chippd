class RedeemRetailCode
  attr_reader :customer_id, :code, :chippd_product_type_id

  def self.call(customer_id, code, chippd_product_type_id = nil)
    new(customer_id, code, chippd_product_type_id).call
  end

  def initialize(customer_id, code, chippd_product_type_id = nil)
    @customer_id = customer_id
    @code = CodeByRedeemQuery.call(code)
    @chippd_product_type_id = chippd_product_type_id
  end

  def call
    build_page
    mark_code_redeemed
  end

  protected

  def build_page
    RetailPageBuilder.call(customer_id, code.to_param, chippd_product_type_id)
  end

  def mark_code_redeemed
    code.redeem!(customer_id)
  end
end
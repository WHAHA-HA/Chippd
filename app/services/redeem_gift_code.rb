class RedeemGiftCode
  attr_reader :customer_id, :code, :chippd_product_id, :verifier

  def self.call(customer_id, code, chippd_product_id = nil)
    new(customer_id, code, chippd_product_id).call
  end

  def initialize(customer_id, code, chippd_product_id = nil)
    @customer = Customer.find(customer_id)
    @code = code
    @order = OrderByGiftCodeQuery.call(code)
  end

  def call
    mark_code_redeemed
    build_page
  end

  protected

  def mark_code_redeemed
    order.update_attributes(:gift_code_redeemed => true, :gift_code_redeemed_by => customer.id)
  end

  def build_page
    OnlineOrderPageBuilder.call(customer.to_param, order.to_param)
  end
end

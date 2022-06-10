class OrderByGiftCodeQuery
  attr_reader :code

  def self.call(code)
    new(code).call
  end

  def initialize(code)
    @code = code
  end

  def call
    Order.where(:gift_code => code).where(:gift_code_redeemed => false).first
  end
end
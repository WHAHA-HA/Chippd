class CodeByRedeemQuery
  attr_reader :code

  def self.call(code)
    new(code).call
  end

  def initialize(code)
    @code = code
  end

  def call
    Code.unused.where(:redeem => code).first
  end
end
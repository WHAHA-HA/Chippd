class RetailBatchGenerator < BatchGenerator
  protected

  def build_code_object(code)
    Code.new(:value => code.value, :redeem => code.redeem)
  end

  RetailCode = Struct.new(:value, :redeem)
  def generate_codes
    @codes = combined_code_values_and_redeems.collect { |a| RetailCode.new(a[0], a[1]) }
  end

  def combined_code_values_and_redeems
    code_values.zip(code_redeems)
  end

  def code_values
    CodeValueGenerator.call(code_count_needed_to_complete_batch)
  end

  def code_redeems
    CodeRedeemGenerator.call(code_count_needed_to_complete_batch)
  end
end

class PercentageDiscount < Discount
  field :amount, :type => Integer

  validates :amount, :presence => true,
            :numericality => {
              :only_integer => true,
              :greater_than_or_equal_to => 1,
              :less_than_or_equal_to => 100
            }

  # Public: Apply this discount to the value passed in.
  #
  # value_to_be_discounted - A Money object that this discount will be applied to.
  #
  # Returns a Money object, either the value to be discounted minus this discount
  #   or zero, whichever is greater.
  def apply(value_to_be_discounted)
    value_to_be_discounted * percentage
  end

private

  # Private: The amount of this discount converted to a float suitable for calculation
  #
  # Returns a float representation of the amount so it can be multiplied
  #   against a value.
  def percentage
    amount.to_f / 100.to_f
  end
end

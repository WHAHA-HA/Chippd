class DollarAmountDiscount < Discount
  field :amount_in_cents, :type => Integer, :default => 0

  validates :amount, :presence => true, 
            :numericality => {
              :greater_than => 0
            }

  # Public: Gets the amount of a product.
  #
  # Returns a Money object based on the value of #amount_in_cents and #currency.
  def amount
    Money.new(self.amount_in_cents, configatron.default_currency)
  end

  # Public: Sets the amount of a product.
  #
  # val - A String or Numeric representation of the product's amount.
  #
  # Returns the value of #amount_in_cents.
  def amount=(val)
    self.amount_in_cents = val.to_money.cents
  end

  # Public: Apply this discount to the value passed in.
  #
  # value_to_be_discounted - A Money object that this discount will be applied to.
  #
  # Returns a Money object, either the amount of this discount or, if the value
  #   to be discounted minus the discount amount is less than or equal to zero,
  #   then return the value passed in to avoid negative totals.
  def apply(value_to_be_discounted)
    value_with_discount_applied = value_to_be_discounted - amount
    value_with_discount_applied > 0 ? amount : value_to_be_discounted
  end
end

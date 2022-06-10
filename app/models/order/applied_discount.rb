class AppliedDiscount
  include Mongoid::Document
  embedded_in :order
  belongs_to :discount

  field :amount_in_cents, :type => Integer, :default => 0
  field :name, :type => String
  field :code, :type => String

  validates :discount, :presence => true
  validates :code, :presence => true

  set_callback(:create, :before) do |document|
    document.name = document.discount.name
    document.amount = document.discount.apply(document.order.subtotal)
  end

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
end

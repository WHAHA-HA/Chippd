class LineItem
  include Mongoid::Document

  embedded_in :order

  belongs_to :product
  belongs_to :product_collection
  belongs_to :chippd_product_type

  field :product_name, :type => String
  field :chippd_product_type_name, :type => String
  field :product_collection_name, :type => String
  field :price_each_in_cents, :type => Integer, :default => 0
  field :key, :type => String
  field :quantity, :type => Integer, :default => 1
  field :options, :type => Array, :default => []
  field :codes_array, :type => Array, :default => []

  delegate :greeting_card?, :to => :product

  validates :price_each_in_cents, :presence => true,
    :numericality => true
  validates :quantity, :presence => true,
    :numericality => true

  set_callback(:save, :before) do |document|
    document.set_association_names
  end

  set_callback(:save, :after) do |document|
    document.order.recalculate_subtotal!
  end

  set_callback(:destroy, :after) do |document|
    document.order.recalculate_subtotal!
  end

  def update_quantity_by(_quantity)
    self.inc(:quantity, _quantity.to_i)
  end

  def codes
    self.codes_array.join(',')
  end

  def codes=(_codes)
    self.codes_array = _codes.split(',').collect(&:strip).collect(&:upcase).reject(&:blank?)
  end

  # Public: Build a LineItem object from a Product's attributes.
  #
  # product - A Product object to build the LineItem from.
  #
  # Returns a LineItem object.
  def self.build_from_product(product)
    line_item = LineItem.new
    line_item.product = product
    line_item.chippd_product_type = product.default_chippd_product_type
    line_item
  end

  # Public: Calculate total price of line item
  #
  # Returns a Money object based on the value of #price_each_in_cents and #currency.
  def price
    self.price_each * self.quantity
  end

  # Public: Gets the price_each of a product.
  #
  # Returns a Money object based on the value of #price_each_in_cents and #currency.
  def price_each
    Money.new(self.price_each_in_cents, configatron.default_currency)
  end

  # Public: Sets the price_each of a product.
  #
  # val - A String or Numeric representation of the product's price_each.
  #
  # Returns the value of #price_each_in_cents.
  def price_each=(val)
    self.price_each_in_cents = val.to_money.cents
  end

  def image
    self.product.default_image
  end

  def page_template_id
    self.product.page_template_id
  end

protected

  def set_association_names
    self.chippd_product_type_name = self.chippd_product_type.name
    self.product_name = self.product.name
    self.product_collection = self.product.product_collection
    self.product_collection_name = self.product_collection.name
  end
end

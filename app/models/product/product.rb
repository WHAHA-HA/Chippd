class Product
  include Mongoid::Document
  include Mongoid::Timestamps
  include HasVisibility
  include Mongoid::Orderable

  belongs_to :product_collection
  belongs_to :page_template

  has_and_belongs_to_many :chippd_product_types
  has_many :preorders

  paginates_per 50

  embeds_many :images, :class_name => "ProductImage"
  embeds_many :details, :class_name => "ProductDetail"

  field :name, :type => String
  field :description, :type => String
  field :price_in_cents, :type => Integer, :default => 0
  field :preorder, :type => Boolean, :default => false
  field :sold_out, :type => Boolean, :default => false
  field :contact_for_purchase, :type => Boolean, :default => false
  field :greeting_card, :type => Boolean, :default => false

  orderable :scope => :product_collection

  validates :name, :presence => true
  validates :description, :presence => true
  validates :price_in_cents, :numericality => true

  default_scope order_by(:position.asc)

  # Public: The default image for a product.
  #
  # Returns the first, visible image.
  def default_image
    self.images.visible.first
  end

  # Public: Gets the price of a product.
  #
  # Returns a Money object based on the value of #price_in_cents and #currency.
  def price
    Money.new(self.price_in_cents, configatron.default_currency)
  end

  # Public: Sets the price of a product.
  #
  # val - A String or Numeric representation of the product's price.
  #
  # Returns the value of #price_in_cents.
  def price=(val)
    self.price_in_cents = val.to_money.cents
  end

  # Public: The default chipp'd product type for a product.
  #
  # Returns the first associated chipp'd product type.
  def default_chippd_product_type
    self.chippd_product_types.first
  end

  def greeting_card?
    greeting_card
  end
end

class Order
  include Mongoid::Document
  include Mongoid::Timestamps
  include OrderState
  include OrderShipping

  cattr_accessor :gift_code_salt
  @@gift_code_salt = "f61317de12323202f28e4747fdcb5d5c28bcfe26ded318d5e3fecb8b4bb94248d33b515adfe2720035e2f85c1f220c8ec3b83fcf82d1b84ac8a818526c152232"
  cattr_accessor :number_salt
  @@number_salt = "f61317de12323202f28e4747fdcb5d5c28bcfe26ded318d5e3fecb8b4bb94248d33b515adfe2720035e2f85c1f220c8ec3b83fcf82d1b84ac8a818526c152232"

  embeds_many :line_items do
    def find_existing_or_create(params)
      if existing = where(:product_id => params[:product_id], :chippd_product_type_id => params[:chippd_product_type_id]).first
        existing.update_quantity_by(params[:quantity])
      else
        create!(params)
      end
    end
  end
  embeds_one :shipping_address, :class_name => "Address"
  embeds_one :billing_address, :class_name => "Address"
  embeds_one :applied_discount
  embeds_one :payment_card
  belongs_to :customer

  field :subtotal_in_cents, :type => Integer, :default => 0
  field :sales_tax_in_cents, :type => Integer, :default => 0
  field :shipping_cost_in_cents, :type => Integer, :default => 0
  field :billing_same_as_shipping, :type => Boolean, :default => true
  field :shipping_option, :type => Symbol
  field :is_gift, :type => Boolean, :default => false
  field :gift_recipient_email, :type => String
  field :gift_recipient_message, :type => String
  field :gift_code, :type => String
  field :gift_code_redeemed, :type => Boolean, :default => false
  field :gift_code_redeemed_by, :type => String
  field :stripe_charge_id, :type => String
  field :number, :type => String
  field :tracking_number, :type => String
  field :estimated_delivery_date, :type => String

  attr_accessor :discount_code

  validates :gift_recipient_email, :presence => true,
            :format => {
              :with => configatron.email_regex,
              :message => "is not a valid email address"
            }, :if => Proc.new { |o| o.is_gift && o.story? }

  accepts_nested_attributes_for :line_items, :shipping_address, :billing_address

  set_callback(:save, :before) do |document|
    unless document.complete?
      document.line_items.each do |line_item|
        line_item.destroy if line_item.quantity.zero?
      end
      document.recalculate_subtotal
      document.apply_discount
    end
  end

  set_callback(:save, :after) do |document|
    if document.canceled?
      document.pages.destroy
    elsif document.complete?
      document.line_items.each do |line_item|
        Page.find_and_update_codes_by_order_line_item(line_item)
      end
    end
  end

  def self.most_recent
    complete.order_by(:purchased_at.desc).first
  end

  def chippd_product_type_id
    self.line_items.blank? ? nil : self.line_items.first.chippd_product_type_id
  end

  # Public: Gets the subtotal of a product.
  #
  # Returns a Money object based on the value of #subtotal_in_cents and #currency.
  def subtotal
    Money.new(self.subtotal_in_cents, configatron.default_currency)
  end

  # Public: Sets the subtotal of a product.
  #
  # val - A String or Numeric representation of the product's subtotal.
  #
  # Returns the value of #subtotal_in_cents.
  def subtotal=(val)
    self.subtotal_in_cents = val.to_money.cents
  end

  # Public: Gets the sales_tax of a product.
  #
  # Returns a Money object based on the value of #sales_tax_in_cents and #currency.
  def sales_tax
    Money.new(self.sales_tax_in_cents, configatron.default_currency)
  end

  # Public: Sets the sales_tax of a product.
  #
  # val - A String or Numeric representation of the product's sales_tax.
  #
  # Returns the value of #sales_tax_in_cents.
  def sales_tax=(val)
    self.sales_tax_in_cents = val.to_money.cents
  end

  def set_sales_tax
    self.sales_tax = SalesTaxCalculator.new(self).calculate
  end

  # Public: Gets the shipping_cost of a product.
  #
  # Returns a Money object based on the value of #shipping_cost_in_cents and #currency.
  def shipping_cost
    Money.new(self.shipping_cost_in_cents, configatron.default_currency)
  end

  # Public: Sets the shipping_cost of a product.
  #
  # val - A String or Numeric representation of the product's shipping_cost.
  #
  # Returns the value of #shipping_cost_in_cents.
  def shipping_cost=(val)
    self.shipping_cost_in_cents = val.to_money.cents
  end

  # Recalculate subtotal
  def recalculate_subtotal
    self.subtotal = self.line_items.to_a.sum(&:price)
  end

  # Recalculate subtotal
  def recalculate_subtotal!
    self.recalculate_subtotal
    self.save
  end

  def total
    (self.subtotal - self.discount) + self.sales_tax + self.shipping_cost
  end

  def save_cart(params)
    safe_params = { :state => 'cart' }
    safe_params = safe_params.merge({ :line_items_attributes => params[:line_items_attributes] }) if params.has_key?(:line_items_attributes)
    safe_params = safe_params.merge({ :discount_code => params[:discount_code] }) if params.has_key?(:discount_code)
    self.update_attributes(safe_params)
  end

  def pair_with_customer!(current_customer)
    if self.customer_id.blank?
      self.customer_id = current_customer.to_param
      if recent_order = current_customer.orders.most_recent
        self.build_shipping_address
        self.build_billing_address
        self.shipping_address.attributes = recent_order.shipping_address.attributes
        self.billing_address.attributes = recent_order.billing_address.attributes
        self.billing_same_as_shipping = recent_order.billing_same_as_shipping
      end
      self.save
    end
  end

  def initialize_customer_information
    self.build_shipping_address unless self.shipping_address.present?
    self.build_billing_address unless self.billing_address.present?
  end

  def save_customer_information(order_params, current_customer, stripeToken = nil)
    self.initialize_customer_information
    self.attributes = order_params
    self.copy_shipping_address_to_billing_address_if_required

    begin
      stripe_customer = current_customer.find_or_create_stripe_customer(stripeToken)
    rescue Stripe::CardError => error
      self.errors.add(:payment_card, error.message)
      return false
    end

    if stripe_customer
      self.payment_card.destroy if self.payment_card.present?
      self.build_payment_card(:brand => stripe_customer.active_card.type, :last4 => stripe_customer.active_card.last4, :exp_month => stripe_customer.active_card.exp_month, :exp_year => stripe_customer.active_card.exp_year)
    end

    self.shipping_cost = ShippingRate.new(self).rate
    self.set_sales_tax

    self.save
  end

  def discount
    self.applied_discount.present? ? self.applied_discount.amount : Money.new(0, configatron.default_currency)
  end

  def new_discount?
    self.discount_code.present?
  end

  def apply_discount
    # If an applied_discount is already present, save the existing
    #  discount object and destroy the associated applied_discount.
    if self.applied_discount.present?
      existing_discount = self.applied_discount.discount
      self.applied_discount.destroy
    end

    # If there's a new discount, we check its availability and create
    #   an applied_discount for it if available.
    #   TODO: Handle case where an available_discount is not returned
    if self.new_discount?
      available_discount = Discount.visible.where(:code => self.discount_code).first
      if available_discount
        self.create_applied_discount(:discount => available_discount, :code => self.discount_code)
      end
    # If there wasn't a new discount, but there was an existing_discount,
    #   create a fresh applied_discount so the amount is recalculated.
    elsif existing_discount
      self.create_applied_discount(:discount => existing_discount, :code => existing_discount.code)
    # Otherwise, do nothing.
    else
    end
  end

  def complete!(order_params, existing_page_id = nil)
    self.attributes = order_params
    if self.valid?
      begin
        charge = self.customer.charge!(self.total.cents, self.to_param)
        if charge.paid
          self.stripe_charge_id = charge.id
          self.state = 'paid'
          self.purchased_at = Time.now
          self.set_order_number
          self.save

          self.reload

          if self.is_gift && self.story?
            self.set_gift_code!
            OrderMailer.gift(self.to_param).deliver
          else
            OnlineOrderPageBuilder.call(self.customer.to_param, self.to_param, existing_page_id)
          end

          OrderMailer.receipt(self.to_param).deliver
          OrderMailer.notification(self.to_param).deliver

          true
        else
          self.errors.add(:payment_card, "could not be charged")
          false
        end
      rescue Stripe::CardError => e
        self.errors.add(:payment_card, e.message)
        false
      end
    else
      false
    end
  end

  # This is bad, but Chipp'd Product Types need to be re-factored
  def love?
    "4fb135d117320a0001000005" == self.chippd_product_type_id.to_s
  end

  def flock?
    "4fb1360117320a0001000007" == self.chippd_product_type_id.to_s
  end

  def story?
    "4fb1362417320a0001000009" == self.chippd_product_type_id.to_s
  end
  
  def pages
    return [] if line_items.empty?
    line_item_ids = line_items.map { |line_item| line_item.to_param }
    Page.where(:line_items.elem_match => { :line_item_id => { "$in" =>  line_item_ids }})
  end

  protected

  def set_order_number
    record = Object.new
    while record
      random = KeyGenerator.generate(self.class.number_salt, 6)
      record = self.class.where(:number => random).first
    end
    self.number = random
  end

  def set_gift_code!
    record = Object.new
    while record
      random = KeyGenerator.generate(self.class.gift_code_salt, 10)
      record = self.class.where(:gift_code => random).first
    end
    self.update_attribute(:gift_code, random)
  end

  def copy_shipping_address_to_billing_address_if_required
    self.billing_address.attributes = self.shipping_address.attributes if self.billing_same_as_shipping
  end
end

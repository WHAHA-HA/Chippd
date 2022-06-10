class PageLineItem
  include Mongoid::Document

  belongs_to :order
  belongs_to :product
  embedded_in :page

  field :line_item_id, :type => String
  field :product_name, :type => String
  field :quantity, :type => Integer
  field :options, :type => Array
  field :code, :type => String
  field :purchased_at, :type => DateTime
  field :codes, :type => Array, :default => []

  class << self
    def from_order_line_item(line_item)
      self.new do |item|
        item.order_id = line_item.order.id
        item.line_item_id = line_item.id
        item.product_id = line_item.product_id
        item.product_name = line_item.product_name
        item.quantity = line_item.quantity
        item.options = line_item.options
        item.purchased_at = line_item.order.purchased_at
      end
    end

    def from_retail_purchase(code)
      self.new do |item|
        item.product_name = code.product_name
        item.product_id = code.product_id
        item.quantity = 1
        item.purchased_at = Time.zone.now
        item.codes << code.value
      end
    end

    def from_code(code)
      self.new do |item|
        item.quantity = 1
        item.purchased_at = Time.zone.now
        item.codes << code.value
      end
    end

    def find_and_update_codes!(line_item_id, codes)
      li = where(:line_item_id => line_item_id).first
      li.update_codes!(codes) if li
    end
  end

  def order_line_item
    @order_line_item ||= self.order.line_items.find(self.line_item_id)
  end

  def update_codes!(new_codes)
    self.codes = new_codes
    self.save
  end

  def image
    if order?
      order_line_item.image
    elsif product?
      product.default_image
    else
      nil
    end
  end
end

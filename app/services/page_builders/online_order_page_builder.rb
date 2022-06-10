class OnlineOrderPageBuilder
  attr_reader :customer, :order
  attr_accessor :existing_page

  def self.call(customer_id, order_id, existing_page_id = nil)
    new(customer_id, order_id, existing_page_id).call
  end

  def initialize(customer_id, order_id, existing_page_id = nil)
    @customer = Customer.find(customer_id)
    @order = Order.find(order_id)
    check_for_existing_page(existing_page_id) if existing_page_id
  end

  def call
    order.line_items.each { |line_item| OrderLineItemPageBuilder.call(customer, line_item, existing_page) }
  end

  protected

  def check_for_existing_page(existing_page_id)
    page = customer.pages.find(existing_page_id)
    self.existing_page = page if page.chippd_product_type_id == order.chippd_product_type_id
  rescue
  end
end
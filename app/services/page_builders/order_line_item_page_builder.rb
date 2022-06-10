class OrderLineItemPageBuilder
  attr_reader :customer, :line_item, :existing_page

  def self.call(customer, line_item, existing_page = nil)
    new(customer, line_item, existing_page).call
  end

  def initialize(customer, line_item, existing_page = nil)
    @customer = customer
    @line_item = line_item
    @existing_page = existing_page
  end

  def call
    queue_page_decision_or_create_page
    Page.find_and_update_codes_by_order_line_item(line_item)
  end

  protected

  def queue_page_decision_or_create_page
    if matching_page_available?
      append_to_existing_or_queue_page_decision
    else
      create_page
    end
  end

  def append_to_existing_or_queue_page_decision
    if existing_page?
      append_to_existing_page
    else
      queue_page_decision
    end
  end

  def matching_page_available?
    customer.has_matching_page?(line_item.product_collection_id, line_item.chippd_product_type_id, line_item.page_template_id)
  end

  def existing_page?
    existing_page
  end

  def append_to_existing_page
    existing_page.line_items << PageLineItem.from_order_line_item(line_item)
    existing_page.save
  end

  def queue_page_decision
    customer.page_decisions.create(:product_collection_id => line_item.product_collection_id, :chippd_product_type_id => line_item.chippd_product_type_id, :page_template_id => line_item.page_template_id, :line_item => PageLineItem.from_order_line_item(line_item))
  end

  def create_page
    customer.pages.create(:product_collection_id => line_item.product_collection_id, :chippd_product_type_id => line_item.chippd_product_type_id, :page_template_id => line_item.page_template_id, :line_items => [PageLineItem.from_order_line_item(line_item)])
  end
end
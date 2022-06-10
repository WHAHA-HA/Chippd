class RetailPageBuilder
  attr_reader :customer, :chippd_product_type, :code

  def self.call(customer_id, code_id, chippd_product_type_id)
    new(customer_id, code_id, chippd_product_type_id).call
  end

  def initialize(customer_id, code_id, chippd_product_type_id)
    @customer = Customer.find(customer_id)
    @code = Code.find(code_id)
    @chippd_product_type = ChippdProductType.find(chippd_product_type_id)
  end

  def call
    queue_page_decision_or_create_page
  end

  protected

  def queue_page_decision_or_create_page
    if matching_page_available?
      queue_page_decision
    else
      create_page
    end
  end

  def matching_page_available?
    customer.has_matching_page?(product_collection_id, chippd_product_type.to_param, page_template_id)
  end

  def queue_page_decision
    customer.page_decisions.create(:product_collection_id => product_collection_id, :chippd_product_type => chippd_product_type, :page_template_id => page_template_id, :line_item => PageLineItem.from_retail_purchase(code))
  end

  def create_page
    customer.pages.create(:product_collection_id => product_collection_id, :chippd_product_type => chippd_product_type, :page_template_id => page_template_id, :line_items => [PageLineItem.from_retail_purchase(code)])
  end

  def product
    @code.product
  end

  def product_collection_id
    product.product_collection_id
  end

  def page_template_id
    product.page_template_id
  end
end

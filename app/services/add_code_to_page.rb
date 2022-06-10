class AddCodeToPage
  attr_reader :code_value, :page_id, :code, :page

  def self.call(page_id, code_value)
    new(page_id, code_value).call
  end

  def initialize(page_id, code_value)
    @page_id = page_id
    @code_value = code_value
  end

  def call
    find_page
    find_code

    page.line_items << PageLineItem.from_code(code)
    page.save
    code.redeem!(page.customer_id)
  rescue Exception => e
    puts e.class
    puts e.message
  end

  protected

  def find_page
    @page = Page.find(page_id)
  end

  def find_code
    @code = Code.fetch_available(code_value)
  end
end
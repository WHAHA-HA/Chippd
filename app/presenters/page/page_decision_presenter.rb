class PageDecisionPresenter < BasePresenter
  presents :page_decision
  delegate :product_collection_id, :chippd_product_type_id, :page_template_id, :to => :page_decision

  def product_collection
    @product_collection ||= ProductCollectionPresenter.new(page_decision.product_collection, @template)
  end

  def chippd_product_type_name
    page_decision.chippd_product_type.name.downcase
  end

  def chippd_product_type_html_class
    ChippdProductTypePresenter.new(page_decision.chippd_product_type, @template).html_class
  end

  def line_item
    PageLineItemPresenter.new(page_decision.line_item, @template).to_s
  end

  def to_param
    page_decision.to_param
  end
end
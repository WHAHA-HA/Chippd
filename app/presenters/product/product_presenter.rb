class ProductPresenter < BasePresenter
  presents :product
  delegate :name, :default_chippd_product_type, :details, :price, :product_collection_id, :greeting_card?, :to => :product

  def truncated_description
    markdown(truncate(product.description, :length => 250))
  end

  def description
    markdown(product.description)
  end

  def images
    @images ||= product.images.collect { |image| ProductImagePresenter.new(image, @template) }
  end

  def chippd_product_types
    @chippd_product_types ||= product.chippd_product_types.collect { |chippd_product_type| ChippdProductTypePresenter.new(chippd_product_type, @template) }
  end

  def default_image
    ProductImagePresenter.new(product.default_image, @template)
  end

  def formatted_price
    content_tag(:p, number_to_currency(product.price.to_s), :class => 'price') unless product.contact_for_purchase
  end

  def preorder?
    product.preorder
  end

  def sold_out?
    product.sold_out
  end

  def contact_for_purchase?
    product.contact_for_purchase
  end

  def to_param
    product.to_param
  end
end
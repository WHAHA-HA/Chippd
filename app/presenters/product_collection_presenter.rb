class ProductCollectionPresenter < BasePresenter
  presents :product_collection
  delegate :name, :sample_url, :collection_url, :to => :product_collection

  def short_name
    name.gsub("Chipp'd", '').strip
  end

  def long_description
    markdown(product_collection.long_description)
  end

  def fixed_quantity?
    product_collection.fixed_quantity
  end

  def image(alt_text = product_collection.name, size = "800x800#")
    image_tag(image_url, :title => alt_text, :alt => alt_text, :width => 800)
  end

  def image_url
    product_collection.image.remote_url
  end

  def html_class
    to_param
  end

  def to_param
    product_collection.to_param
  end

  def to_s
    name
  end
end
class ChippdProductTypePresenter < BasePresenter
  presents :chippd_product_type
  delegate :name, :to => :chippd_product_type

  def short_name
    name.gsub("Chipp'd", '').strip
  end

  def short_description
    markdown(chippd_product_type.short_description)
  end

  def fixed_quantity?
    chippd_product_type.fixed_quantity
  end

  def image(alt_text = chippd_product_type.name, width = 800)
    image_tag(chippd_product_type.image.remote_url, :title => alt_text, :alt => alt_text, :width => width)
  end

  def html_class
    to_s.downcase.gsub("'", '').parameterize
  end

  def to_param
    chippd_product_type.to_param
  end

  def to_s
    name
  end

  def option_html_class(collection)
    klasses = []
    klasses << "active" if collection.first == chippd_product_type
    klasses << "single" if collection.length == 1
    klasses.join(" ")
  end
end
class Store::ProductsController < Store::BaseController
  before_filter :store_page_id, :if => :page_id?
  helper_method :product_collection

  def index
    @product_collection = ProductCollection.visible.find(params[:product_collection_id])
    @products = ProductPresenter.from_collection(product_collection.products.visible, view_context)
    add_products_breadcrumb
  end

  def index_by_page_template
    @product_collection = ProductCollection.visible.find(params[:product_collection_id])
    page_template = PageTemplate.find(params[:page_template_id])
    eligible_products = product_collection.products.visible & page_template.products.visible
    @products = ProductPresenter.from_collection(eligible_products, view_context)
    add_products_breadcrumb
    flash[:notice] = 'You are currently viewing products that are eligible for addition to your page.'
    render :index
  end

  def show
    @product = Product.visible.find(params[:id])
    @product_collection = @product.product_collection
    add_products_breadcrumb
    @line_item = LineItem.build_from_product(@product)
    @product = ProductPresenter.new(@product, view_context)
    ariane.add @product.name, store_product_path(@product)
  end

  protected

  def product_collection
    @product_collection
  end

  def add_products_breadcrumb
    ariane.add product_collection.to_s, store_products_by_product_collection_path(product_collection.to_param)
  end

  def page_id?
    params[:page_id]
  end

  def store_page_id
    session[:page_id] = params[:page_id]
  end
end

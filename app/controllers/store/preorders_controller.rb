class Store::PreordersController < Store::BaseController
  before_filter :fetch_product

  def create
    preorder = @product.preorders.build(params[:preorder])
    if preorder.save
      head :ok
    else
      head :unprocessable_entity
    end
  end

  protected

  def fetch_product
    @product = Product.find(params[:product_id])
  end
end

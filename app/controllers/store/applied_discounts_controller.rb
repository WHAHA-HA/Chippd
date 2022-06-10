class Store::AppliedDiscountsController < Store::BaseController
  def destroy
    @order = current_order.order
    @order.applied_discount.destroy if @order.applied_discount.present?
    redirect_to store_order_url
  end
end

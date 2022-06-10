class Store::LineItemsController < Store::BaseController
  skip_before_filter :fetch_current_order
  before_filter :fetch_or_create_order

  def create
    # TODO if session[:page_id] is present, ensure the line item being created matches the attributes of the page in the session
    current_order.line_items.find_existing_or_create(params[:line_item])
    redirect_to store_order_url
  end

  def destroy
    if line_item = current_order.line_items.find(params[:id])
      line_item.destroy
    end
    redirect_to store_order_url
  end

protected

  def fetch_or_create_order
    if session[:order_id]
      @current_order = Order.find(session[:order_id])
    else
      @current_order = Order.create
      session[:order_id] = @current_order.id
    end
  rescue Mongoid::Errors::DocumentNotFound
    @current_order = Order.create
    session[:order_id] = @current_order.id
  end
end

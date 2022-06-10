class Store::OrdersController < Store::BaseController
  before_filter :redirect_unless_current_order, :except => [:error]
  before_filter :set_order_instance, :except => [:thank_you, :error]
  before_filter :authenticate_customer!, :except => [:show, :cart, :save_cart]
  layout 'simple', :only => [:thank_you, :error]

  def show
    redirect_to cart_for_store_order_url
  end

  def cart
  end

  def save_cart
    if @order.save_cart(params[:order])
      redirect_to cart_for_store_order_url
    else
      render 'cart'
    end
  end

  def customer_information
    @order.pair_with_customer!(current_customer)
    @order.initialize_customer_information
    prepare_shipping_options
  end

  def save_customer_information
    if @order.save_customer_information(params[:order], current_customer, params[:stripeToken])
      redirect_to review_store_order_url
    else
      prepare_shipping_options
      render 'customer_information'
    end
  end

  def review
  end

  def complete
    if @order.complete!(params[:order], session[:page_id])
      redirect_to thank_you_for_your_store_order_url
    else
      render 'review'
    end
  end

  def thank_you
    session[:order_id] = nil
    session[:chippd_product_type_id] = nil
    if session[:page_id]
      @for_existing_page = true
      session[:page_id] = nil
    end
  end

  def error
  end

  protected

  def redirect_unless_current_order
    redirect_to store_root_url unless current_order?
  end

  def set_order_instance
    @order = current_order.order
  end

  def prepare_shipping_options
    @shipping_options = ShippingOptionQuery.call(@order).collect { |so| [so.name, so.key]}
    @default_shipping_option = @order.shipping_option.present? ? @order.shipping_option : @shipping_options.first[1]
  end
end

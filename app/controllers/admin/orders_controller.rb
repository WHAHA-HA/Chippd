class Admin::OrdersController < Admin::BaseController
  helper_method :order_counts, :presented_order

  def index
    redirect_to paid_admin_orders_url
  end

  def search
    if params[:number].blank?
      redirect_to(paid_admin_orders_url, :alert => "Please enter an order number before you search.") and return
    end

    order = Order.where(:number => params[:number].upcase).first

    if order
      redirect_to(edit_admin_order_url(order))
    else
      redirect_to(paid_admin_orders_url, :alert => "An order with that number could not be found.")
    end
  end

  def paid
    @collection = Order.paid.all
    render 'index'
  end

  def shipped
    @collection = Order.shipped.all
    render 'index'
  end

  def canceled
    @collection = Order.canceled.all
    render 'index'
  end

  def ship
    resource.ship!
    redirect_to edit_admin_order_url(resource)
  end

  def cancel
    resource.cancel!
    redirect_to edit_admin_order_url(resource)
  end

  def invoice
    render :layout => false
  end

  protected

  def order_counts
    {
      :paid => Order.paid.count,
      :shipped => Order.shipped.count,
      :canceled => Order.canceled.count
    }
  end

  def presented_order
    @presented_order ||= OrderPresenter.new(resource, view_context)
  end

  def setup_edit_breadcrumb
    ariane.add "<code>#{resource.number}</code>", edit_resource_path(resource)
  end
end
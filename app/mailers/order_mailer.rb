class OrderMailer < BaseMailer

  def receipt(order_id)
    fetch_order(order_id)
    mail :to => @customer_email, :subject => "Thank you for your order!"
  end

  def gift(order_id)
    fetch_order(order_id)
    mail :to => @order.gift_recipient_email, :subject => "Someone's Just Bought You a Super Special Gift!"
  end

  def shipped(order_id)
    fetch_order(order_id)
    mail :to => @customer_email, :subject => "Your package has left the building!"
  end

  def canceled(order_id)
    fetch_order(order_id)
    mail :to => @customer_email, :subject => "Your order has been canceled!"
  end

  def notification(order_id)
    fetch_order(order_id)
    mail :to => configatron.email_addresses.notification, :subject => "A new order has been received."
  end

  protected

  def fetch_order(order_id)
    order = Order.find(order_id)
    @order = OrderPresenter.new(order, view_context)
    @customer_email = order.customer.email
  end
end

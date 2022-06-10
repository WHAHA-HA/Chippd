class AuctionNotifyOutbidWorker < ProcessingWorker

  def perform(page_id, customer_id)

    customer = Customer.find(customer_id)

    PushNotification.deliver(customer.devices, I18n.t("notifications.push.auction_outbid"), :page_id => page_id)
    CustomerMailer.auction_outbid(customer_id).deliver
  end

end

class AuctionNotifyBiddersWorker < ProcessingWorker

  def perform(auction_id)

    auction = Page.find_and_return_section(auction_id)

    customers = []
    auction.bids.each do |bid|
      unless customers.include?(bid.customer.to_param)
        PushNotification.deliver(bid.customer.devices, I18n.t("notifications.push.auction_over"))
        CustomerMailer.auction_over(bid.customer.to_param, auction.to_param).deliver
        customers << bid.customer.to_param
      end
    end

    # notify winner
    if auction.winner
      PushNotification.deliver(auction.winner.devices, I18n.t("notifications.push.auction_won"))
      CustomerMailer.auction_won(auction.winner.to_param, auction.to_param).deliver
    end

  end

end

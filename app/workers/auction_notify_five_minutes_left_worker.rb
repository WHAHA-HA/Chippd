class AuctionNotifyFiveMinutesLeftWorker < ProcessingWorker

  def perform

    Page.with_active_sections.each do |page|
      page.sections.each do |section|

        if section.is_a?(Auction) && section.live && !section.notified_at_five && section.has_less_than_five_min_left?

          section.bids.each do |bid|

            if bid.notify_ending
              PushNotification.deliver(bid.customer.devices, I18n.t("notifications.push.auction_ending", :page_name => page.name), :page_id => page.to_param)
              CustomerMailer.auction_ending(bid.customer.to_param).deliver
            end

          end

          section.update_attribute(:notified_at_five, true)
        end

      end
    end

  end
end

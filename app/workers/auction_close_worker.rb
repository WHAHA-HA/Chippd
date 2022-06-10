class AuctionCloseWorker < ProcessingWorker

  def perform

    Page.with_active_sections.each do |page|
      page.sections.each do |section|

        if section.is_a?(Auction) && section.live && !section.has_time_remaining?
          AuctionNotifyBiddersWorker.perform_async(section.to_param)
          section.update_attribute(:live, false)
        end

      end
    end

  end
end

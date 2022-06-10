class MyChippd::AuctionsController < MyChippd::BaseController
  helper_method :preview?

  def bid
    @bid = auction.bids.build(params[:bid])
    @bid.customer = current_customer

    if auction.accept_bid?(@bid) && @bid.save
      @notice     = "bid accepted!"
      @high_bid   = @bid.amount
      @total_bids = auction.total_bids
      auction.notify_old_high_bidder
    else
      @notice = "problem accepting bid - please try again."
    end
  end

  # hack to allow auction pages to be shown in browser
  # need to come up with more general strategy...
  def show
    allow_show = false
    page = Page.find(params[:page_id])

    # only allow ebola page to be shown
    if page.to_param == '54d274234c06fcc008000001'
      allow_show = true
    end

    if allow_show
      @page = PagePresenter.new(page, view_context)
      render '/my_chippd/pages/show', :layout => false
    else
      redirect_to root_url
    end
  end

  def close
    # could be hit multiple times as client fires callback...
    # if nobody is watching the auction, close happens by AuctionCloseWorker
    if auction.live
      AuctionNotifyBiddersWorker.perform_async(params[:id])
      auction.update_attribute(:live, false)
    end
    redirect_to my_chippd_page_auctions_path(params[:page_id])
  end

  private

  def auction
    @auction ||= Page.find_and_return_section(params[:id])
  end

  def preview?
    false
  end

end

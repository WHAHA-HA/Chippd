class AuctionPresenter < PageSectionPresenter
  delegate :photo?, :video?, :total_bids, :num_views, :live, :bids, :has_time_remaining?, :winner, :must_submit_addr, :must_submit_phone, :to => :page_section

  def title
    handle_none(page_section.title) do
      content_tag(:figcaption, page_section.title)
    end
  end

  def description
    handle_none(page_section.description) do
      content_tag(:figcaption, page_section.description)
    end
  end

  def image
    image_tag(page_section.image.remote_url, :alt => "photo")
  end

  def video_embed
    content_tag(:video, :class => 'sublime', :width => 551, :height => 310, :poster => page_section.poster.remote_url, :preload => 'none', 'data-settings' => player_settings) do
      page_section.versions.each do |version|
        concat(source_tag_for(version))
      end
    end
  end

  def highest_bid
    if bid = page_section.highest_bid
      bid.amount
    else
      0
    end
  end

  def auction_end_for_js
    d = page_section.end_date
    t = page_section.end_time

    "#{d.year}, #{d.month - 1}, #{d.day}, #{t.hour}, #{t.min}, #{t.sec}"
  end

  def update_num_views
    page_section.update_attribute(:num_views, page_section.num_views += 1)
  end

  def open_for_bidding?
    page_section.live && page_section.has_time_remaining?
  end

  def awaiting_start?
    !page_section.live && page_section.has_time_remaining?
  end

  def closed?
    !page_section.live && !page_section.has_time_remaining?
  end

  def contact_info
    "<span>#{page_section.contact_name}</span><span>#{page_section.contact_email}</span><span>#{page_section.contact_phone}</span>".html_safe
  end

  def claim_info
     str = "To claim your item, please provide #{page_section.contact_name} with your "

     if page_section.must_submit_addr && page_section.must_submit_phone
       str += "mailing address and phone number."
     elsif page_section.must_submit_addr
       str += "mailing address."
     elsif page_section.must_submit_phone
       str += "phone number."
     else
       str += "information."
     end
  end

  protected

  def source_tag_for(version)
    %{\n<source src="#{version.file.remote_url}" type='#{version.codec}' />}.html_safe
  end

  def sortable_content
    page_section.description? ? page_section.description : 'Auction'
  end

  def uid
    [page_section.page.customer_id, page_section.page.to_param, page_section.to_param].join('-')
  end

  def player_settings
    {
      'autoresize' => 'fit',
      'player-kit' => '2',
      'uid' => uid
    }.collect { |i| i.join(':') }.join('; ')
  end

end

class Auction < PageSectionWithAttachments
  embeds_many :versions, :class_name => "VideoVersion", :cascade_callbacks => true
  embeds_many :bids

  field :media_type,         :type => String # photo or video
  field :job_id,             :type => String
  field :title,              :type => String
  field :description,        :type => String
  field :end_date,           :type => Date
  field :end_time,           :type => Time
  field :live,               :type => Boolean, :default => false
  field :num_views,          :type => Integer, :default => 0
  field :minimum_bid,        :type => Integer, :default => 0
  field :must_submit_addr,   :type => Boolean, :default => false
  field :must_submit_phone,  :type => Boolean, :default => false
  field :contact_name,       :type => String
  field :contact_email,      :type => String
  field :contact_phone,      :type => String
  field :notified_at_five,   :type => Boolean, :default => false

  image_attachment_fields :original, :image, :poster

  image_accessor :original do
    copy_to(:image){|a| a.thumb('600x').process(:auto_orient) }
  end
  image_accessor :image
  image_accessor :poster

  accepts_nested_attributes_for :bids

  validates :end_date, :end_time, :presence => true

  def accept_bid?(bid)
    return false unless bid.valid?

    unless live
      bid.errors.add(:base, "Auction has closed.")
      return false
    end

    unless has_time_remaining?
      bid.errors.add(:base, "Auction time has expired.")
      return false
    end

    if bid.amount <= minimum_bid
      bid.errors.add(:base, "Bid less than minimum allowed.")
      return false
    end

    unless bid == highest_bid
      high_bid = highest_bid.amount
      if bid.amount <= high_bid
        bid.errors.add(:base, "Please bid higher than $#{high_bid}.")
        return false
      end
    end

    true
  end

  def has_time_remaining?
    end_date_time - DateTime.current > 0 ? true : false
  end

  def has_less_than_five_min_left?
    (end_date_time - 5.minutes) - DateTime.current < 0 ? true : false
  end

  def end_date_time
    @end_date_time ||= DateTime.new(end_date.year, end_date.month, end_date.day,
                                    end_time.hour, end_time.min,   end_time.sec, end_time.zone)
  end

  def notify_old_high_bidder
    old_high_bid = bids.sort{ |bid1, bid2| bid2.amount <=> bid1.amount }[1] rescue nil

    if old_high_bid && old_high_bid.notify_out_bid
      AuctionNotifyOutbidWorker.perform_async(page.to_param, old_high_bid.customer.to_param)
    end
  end

  def winner
    highest_bid.try(:customer)
  end

  def photo?
    media_type == 'photo'
  end

  def video?
    media_type == 'video'
  end

  def formatted_end_time
    self.end_time ? self.end_time.stamp('11:00 PM') : ''
  end

  def highest_bid
    bids.max_by(&:amount)
  end

  def total_bids
    bids.size
  end

  def asset_json
    if photo? && image_uid.present?
      {
        id:  image_uid,
        url: image.remote_url
      }.to_json
    elsif video? && versions.present?
      {
        id:  versions.last.id,
        url: versions.last.id
      }.to_json
    else
      {}
    end
  end

  def storage_used
    if photo?
      calculate_storage_used_for(:original)
    elsif video?
      calculate_storage_used_for(:poster) + calculate_storage_used_for(:original)
    end
  end
end

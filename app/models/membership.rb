class Membership
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :page
  belongs_to :customer

  field :key, :type => String
  field :last_viewed_at, :type => DateTime
  field :privacy, :type => Symbol
  field :access, :type => Boolean, :default => true

  default_scope order_by(:last_viewed_at.desc)

  def name
    customer.full_name
  end

  def customer_devices
    customer.devices
  end

  def toggle_access!
    update_attribute(:access, !access)
  end

  def log_page_view!
    update_attribute(:last_viewed_at, Time.now)
  end
end
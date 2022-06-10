class Page
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :page_template
  belongs_to :product_collection
  belongs_to :chippd_product_type
  belongs_to :customer
  has_many :memberships

  embeds_many :line_items, :class_name => "PageLineItem"
  embeds_many :sections, :class_name => "PageSection"

  field :name, :type => String
  field :heading, :type => String
  field :subheading, :type => String
  field :member_ids, :type => Array, :default => []
  field :notification_last_sent_at, :type => DateTime
  field :b2b_enabled, :type => Boolean, :default => false
  field :monthly_cost_currency, :type => String, :default => '$'
  field :estimated_monthly_cost_per_user_in_cents, :type => Integer, :default => 0

  validates :name, :presence => true
  validates :monthly_cost_currency, :presence => true
  validates :estimated_monthly_cost_per_user, :presence => true, :numericality => {
    :greater_than_or_equal_to => 0
  }

  validate :change_page_template

  default_scope order_by(:updated_at.desc)

  set_callback(:validation, :before, :unless => :persisted?) do |document|
    document.set_name
  end

  def self.by_page_template(page_template_id)
    where(:page_template_id => page_template_id)
  end

  def self.by_chippd_product_type(chippd_product_type_id)
    where(:chippd_product_type_id => chippd_product_type_id)
  end

  def self.by_product_collection(product_collection_id)
    where(:product_collection_id => product_collection_id)
  end

  def self.find_and_return_section(_section_id)
    page = where(:sections.elem_match => { :_id => Moped::BSON::ObjectId.from_string(_section_id) }).first
    page.sections.find(_section_id) if page
  end

  def self.with_pending_sections
    where('sections.state' => :pending)
  end

  def self.with_active_sections
    where('sections.state' => :active)
  end

  def self.find_and_update_codes_by_order_line_item(_line_item)
    page = where(:line_items.elem_match => { :line_item_id => _line_item.id.to_s }).first
    page.line_items.find_and_update_codes!(_line_item.id.to_s, _line_item.codes_array) if page
  end

  def self.by_code(code)
    where(:line_items.elem_match => { :codes => code }).first
  end

  def devices
    self.memberships.collect(&:customer_devices).flatten
  end

  def codes
    self.line_items.collect(&:codes).flatten
  end

  def members
    if @members
      @members
    else
      customer_ids = self.memberships.collect(&:customer_id)
      @members = Customer.where(:_id.in => customer_ids)
    end
  end

  def members_who_have_not_responded_to(rsvp)
    responded = rsvp.responses.collect(&:customer_id)
    memberships.reject { |membership| responded.include?(membership.customer_id) }
  end

  def push_notification_sent?
    notification_last_sent_at.present?
  end

  def eligible_for_notification?
    self.notification_last_sent_at.nil? || 24.hours.ago > self.notification_last_sent_at
  end

  def log_notification_time!
    self.update_attribute(:notification_last_sent_at, Time.now)
  end

  def eligible_to_notify_next_at
    self.notification_last_sent_at.nil? ? Time.now : 24.hours.since(self.notification_last_sent_at)
  end

  def page_number
    self.customer.pages.index(self) + 1
  end

  def customer_name
    self.customer.full_name
  end

  def to_s
    name
  end

  def has_rsvp?
    sections.where(:_type => 'Rsvp').exists?
  end

  def storage_used
    sections.sum(&:storage_used)
  end

  def track_storage_used!
    Keen.publish(:storage_used, { :page_id => self.id.to_s, :storage_used => storage_used })
  end

  def b2b_enabled?
    b2b_enabled
  end

  def estimated_monthly_cost?
    !estimated_monthly_cost_per_user.zero?
  end

  # Public: Gets the estimated_monthly_cost_per_user of a page.
  #
  # Returns a Money object based on the value of #estimated_monthly_cost_per_user_in_cents and #currency.
  def estimated_monthly_cost_per_user
    Money.new(self.estimated_monthly_cost_per_user_in_cents, configatron.default_currency)
  end

  # Public: Sets the estimated_monthly_cost_per_user of a page.
  #
  # val - A String or Numeric representation of the page's estimated_monthly_cost_per_user.
  #
  # Returns the value of #estimated_monthly_cost_per_user_in_cents.
  def estimated_monthly_cost_per_user=(val)
    self.estimated_monthly_cost_per_user_in_cents = val.to_money.cents
  end

  def estimated_monthly_cost
    estimated_monthly_cost_per_user * unique_visitors('this_month')
  end

  def unique_visitors(timeframe)
    filters = [{:property_name => 'customer_id', :operator => 'eq', :property_value => self.id.to_s}]
    params = { :target_property => "customer_id", :filters => filters }
    params.merge!(:timeframe => timeframe) if timeframe
    Keen.count_unique("visits", params)
  end

  protected

  def set_name
    self.name = "#{self.customer_name}'s Page ##{self.page_number}" if self.name.blank?
  end

  def change_page_template
    if page_template_id_changed? && self.persisted? && sections.exists?
      errors.add(:page_template_id, "Can't change the template because the page has sections")
    end
  end
end

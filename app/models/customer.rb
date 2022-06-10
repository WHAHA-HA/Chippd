class Customer
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :orders, :dependent => :destroy
  has_many :pages, :dependent => :destroy
  has_many :memberships, :dependent => :destroy

  embeds_many :page_decisions
  embeds_many :devices

  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable, :confirmable

  field :first_name, :type => String
  field :last_name, :type => String
  field :stripe_id, :type => String

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Confirmable
  field :confirmation_token,   :type => String
  field :confirmed_at,         :type => DateTime
  field :confirmation_sent_at, :type => DateTime

  # API Token
  field :authentication_token, :type => String, :default => ""

  attr_accessor :name

  validates :name, :presence => {
    :if => :v1_api?
  }

  validates :first_name, :presence => true

  validates :last_name, :presence => {
    :unless => :v1_api?
  }

  set_callback(:validation, :before) do |document|
    document.set_first_and_last_name_from_name if document.name.present?
  end

  set_callback(:save, :before) do |document|
    document.ensure_authentication_token
  end

  class << self
    def find_for_token_authentication(conditions)
      find_for_authentication(:authentication_token => conditions[:authentication_token])
    end
  end

  def owner?(page)
    page.customer_id.to_s == self.to_param
  end

  def send_reset_password_instructions
    generate_reset_password_token! if should_generate_reset_token?
    CustomerMailer.reset_password_instructions(self.to_param).deliver
  end

  def private_memberships
    memberships_by_privacy_type(:private)
  end

  def public_memberships
    memberships_by_privacy_type(:public)
  end

  def add_to_or_create_page(choice, page_decision_id)
    page_decision = self.page_decisions.find(page_decision_id)
    line_item_attributes = page_decision.line_item.attributes.except("_id")

    if choice == 'new_page'
      self.pages.create(:product_collection_id => page_decision.product_collection_id, :chippd_product_type_id => page_decision.chippd_product_type_id, :page_template_id => page_decision.page_template_id, :line_items => [PageLineItem.new(line_item_attributes)])
    else
      page = self.pages.find(choice)
      page.line_items << PageLineItem.new(line_item_attributes)
      page.save
    end
    page_decision.settle!
  end

  def pages_matching(product_collection_id, chippd_product_type_id, page_template_id)
    self.pages.by_product_collection(product_collection_id).by_chippd_product_type(chippd_product_type_id).by_page_template(page_template_id).to_a
  end

  def has_matching_page?(product_collection_id, chippd_product_type_id, page_template_id)
    self.pages_matching(product_collection_id, chippd_product_type_id, page_template_id).present?
  end

  def find_or_create_stripe_customer(stripe_token)
    if self.has_stripe_customer_profile?
      stripe_customer = self.retrieve_stripe_customer
      stripe_customer.card = stripe_token
      stripe_customer.save
      stripe_customer
    else
      self.create_stripe_customer(stripe_token)
    end
  rescue Stripe::InvalidRequestError
    self.stripe_id = nil
    retry
  end

  def has_stripe_customer_profile?
    self.stripe_id.present?
  end

  def create_stripe_customer(stripe_token)
    stripe_customer = Stripe::Customer.create(
      :description => "Chipp'd Customer ##{self.to_param}",
      :card => stripe_token,
      :email => self.email
    )
    self.stripe_id = stripe_customer.id
    self.save
    stripe_customer
  end

  def retrieve_stripe_customer
    Stripe::Customer.retrieve(self.stripe_id)
  end

  def charge!(amount_in_cents, order_id)
    Stripe::Charge.create(
      :amount => amount_in_cents,
      :currency => "usd",
      :customer => self.stripe_id,
      :description => "Chipp'd Order ##{order_id}"
    )
  end

  def to_s
    "#{full_name} (#{email})"
  end

  def v1_api!
    @v1_api = true
  end

  def v1_api?
    @v1_api
  end

  def full_name
    [first_name, last_name].compact.join(' ')
  end

  def set_first_and_last_name_from_name
    fn, ln = self.name.split(' ', 2)
    self.first_name = fn
    self.last_name = ln
  end

  protected

  def ensure_authentication_token
    if self.authentication_token.blank?
      record = Object.new
      while record
        random = ApiKeyGenerator.generate
        record = self.class.where(:authentication_token => random).first
      end
      self.authentication_token = random
    end
  end

  def memberships_by_privacy_type(privacy_type)
    product_type_ids = ChippdProductType.where(:privacy => privacy_type).all.collect(&:_id)
    page_ids = Page.where(:chippd_product_type_id.in => product_type_ids).all.collect(&:_id)
    self.memberships.where(:page_id.in => page_ids)
  end
end

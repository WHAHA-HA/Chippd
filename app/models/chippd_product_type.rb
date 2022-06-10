class ChippdProductType
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Orderable

  PRIVACY_OPTIONS = [:public, :private]

  has_and_belongs_to_many :products
  has_many :pages

  field :name, :type => String
  field :admin_note, :type => String
  field :short_description, :type => String
  field :fixed_quantity, :type => Integer
  field :force_unique_page, :type => Boolean, :default => false
  field :privacy, :type => Symbol, :default => :public
  field :image_uid, :type => String
  image_accessor :image

  default_scope order_by(:position.asc)

  validates :name, :presence => true
  validates :short_description, :presence => true
  validates :privacy, :presence => true,
    :inclusion => {
      :in => PRIVACY_OPTIONS
    }
  validates :fixed_quantity,
    :numericality => {
      :allow_blank => true
    }

  orderable

  def fixed_quantity?
    self.fixed_quantity.present? && self.fixed_quantity > 0
  end

  def private?
    self.privacy == :private
  end

  def to_option
    [name, admin_note].reject(&:blank?).join(' - ')
  end

  def to_s
    name
  end
end

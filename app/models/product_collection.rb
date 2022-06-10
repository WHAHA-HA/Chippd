class ProductCollection
  include Mongoid::Document
  include Mongoid::Timestamps
  include HasVisibility
  include Mongoid::Orderable
  include Mongoid::Slug

  has_many :products

  field :name, :type => String
  field :filter_text, :type => String
  field :long_description, :type => String
  field :sample_url, :type => String, :default => '/store'
  field :collection_url, :type => String, default: -> { "/store/#{self.id.to_s}/products" }

  field :image_uid, :type => String
  image_accessor :image

  field :inverse_image_uid, :type => String
  image_accessor :inverse_image

  field :how_it_works_image_uid, :type => String
  image_accessor :how_it_works_image

  slug :name, :index => true
  orderable

  validates_presence_of :name, :long_description, :filter_text, :sample_url, :collection_url

  default_scope order_by(:position.asc)

  def to_s
    self.name
  end
end

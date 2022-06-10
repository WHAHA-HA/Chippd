class Content
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  embeds_many :content_locations

  field :name, :type => String
  field :body, :type => String
  field :_slugs, :type => Array, :default => []

  slug :name, :index => true, :permanent => true

  default_scope order_by(:name.asc)

  validates_presence_of :name, :body

  accepts_nested_attributes_for :content_locations, :allow_destroy => true

  def self.fetch!(slug)
    find(slug.to_s)
  end

  def location_information?
    self.content_locations.present?
  end
end

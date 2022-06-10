class ProductDetail
  include Mongoid::Document
  include Mongoid::Orderable

  embedded_in :product, :inverse_of => :details
  embeds_many :options, :class_name => "DetailOption"

  field :name, :type => String

  validates :name, :presence => true,
    :uniqueness => true

  orderable

  default_scope order_by(:position.asc)
end

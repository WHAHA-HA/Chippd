class DetailOption
  include Mongoid::Document
  include Mongoid::Orderable

  embedded_in :product_detail, :inverse_of => :options

  field :name, :type => String

  validates :name, :presence => true,
    :uniqueness => true

  orderable

  default_scope order_by(:position.asc)
end

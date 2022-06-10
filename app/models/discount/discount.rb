class Discount
  include Mongoid::Document
  include Mongoid::Timestamps
  include HasVisibility

  field :name, :type => String
  field :code, :type => String

  default_scope order_by(:name.asc)

  validates :name, :presence => true
  validates :code, :presence => true
end

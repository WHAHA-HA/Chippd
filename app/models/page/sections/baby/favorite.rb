class Favorite
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Orderable

  embedded_in :babys_favorites_widget

  field :category, :type => String
  field :title,    :type => String

  validates_presence_of :category
  validates_presence_of :title

  orderable

  default_scope order_by(:category.asc)

end

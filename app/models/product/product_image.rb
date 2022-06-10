class ProductImage
  include Mongoid::Document
  include HasVisibility
  include Mongoid::Orderable

  embedded_in :product, :inverse_of => :images

  field :caption, :type => String
  field :image_uid, :type => String
  field :square_uid, :type => String
  field :small_uid, :type => String
  field :medium_uid, :type => String
  field :large_uid, :type => String

  image_accessor :image do
    copy_to(:square) {|a| a.thumb('100x100#') }
    copy_to(:small) {|a| a.thumb('128x72#') }
    copy_to(:medium) {|a| a.thumb('570x420#') }
    copy_to(:large) {|a| a.thumb('800x572#') }
  end
  image_accessor :square
  image_accessor :small
  image_accessor :medium
  image_accessor :large

  orderable

  validates_presence_of :caption, :image

  default_scope order_by(:position.asc)
end

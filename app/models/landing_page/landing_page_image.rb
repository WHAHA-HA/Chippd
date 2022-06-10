class LandingPageImage
  include Mongoid::Document
  include Mongoid::Timestamps
  include HasVisibility
  include Mongoid::Orderable

  orderable

  embedded_in :landing_page, :inverse_of => :images

  field :caption, :type => String
  field :original_uid, :type => String
  field :large_uid, :type => String
  field :medium_uid, :type => String
  field :small_uid, :type => String
  image_accessor :original do
    copy_to(:large) {|a| a.thumb('1600x800#') }
    copy_to(:medium) {|a| a.thumb('800x400#') }
    copy_to(:small) {|a| a.thumb('320x160#') }
  end
  image_accessor :large
  image_accessor :medium
  image_accessor :small

  field :image_uid, :type => String
  image_accessor :image

  default_scope order_by(:position.asc)

  validates_presence_of :caption, :original

  default_scope order_by(:position.asc)
end

class PressRelease
  include Mongoid::Document
  include Mongoid::Timestamps
  include HasVisibility

  field :title, :type => String
  field :published_on, :type => Date
  field :abstract, :type => String
  field :body, :type => String
  field :original_uid, :type => String
  field :thumb_uid, :type => String
  field :image_uid, :type => String

  image_accessor :original do
    copy_to(:thumb) {|a| a.thumb('200x') }
    copy_to(:image) {|a| a.thumb('800x') }
  end
  image_accessor :thumb
  image_accessor :image

  validates_presence_of :title, :published_on, :abstract, :body, :original

  default_scope order_by(:published_on.desc)
end

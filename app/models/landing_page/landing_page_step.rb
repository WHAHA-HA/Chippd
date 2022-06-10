class LandingPageStep
  include Mongoid::Document
  include Mongoid::Timestamps
  include HasVisibility
  include Mongoid::Orderable

  orderable

  embedded_in :landing_page, :inverse_of => :steps

  field :title, :type => String
  field :description, :type => String
  field :image_uid, :type => String
  field :original_uid, :type => String
  image_accessor :original do
    copy_to(:image) {|a| a.thumb('500x380#') }
  end
  image_accessor :image

  validates_presence_of :title, :description, :original

  default_scope order_by(:position.asc)

  def number
    self.landing_page.steps.index(self) + 1
  end
end

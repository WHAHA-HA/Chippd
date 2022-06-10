class PageDecision
  include Mongoid::Document

  belongs_to :page_template
  belongs_to :product_collection
  belongs_to :chippd_product_type

  embeds_one :line_item, :class_name => "PageLineItem"
  embedded_in :customer

  field :settled, :type => Boolean, :default => false

  scope :unsettled, where(:settled => false)

  def settle!
    self.update_attribute(:settled, true)
  end
end

class Code
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  belongs_to :batch
  belongs_to :redeemed_by, :class_name => 'Customer'

  field :value, :type => String
  field :redeem, :type => String
  field :used, :type => Boolean, :default => false

  index({ value: 1 }, { unique: true, name: "code_value_index" })
  index({ redeem: 1 }, { unique: true, name: "code_redeem_index" })
  index({ used: 1 }, { name: "code_used_index" })

  validates_presence_of :value

  delegate :chippd_product_type_ids, :product_name, :product_id, :product, :to => :batch

  def self.used
    where(:used => true)
  end

  def self.unused
    where(:used => false)
  end

  def self.fetch_available(code_value)
    unused.find_by(:value => code_value)
  end

  def to_csv_row
    row = [value]
    row << redeem if redeem.present?
    row
  end

  def redeem!(customer_id)
    update_attributes({
      :used => true,
      :redeemed_by_id => customer_id
    })
  end
end
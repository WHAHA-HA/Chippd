class Batch
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  has_many :codes, :dependent => :destroy
  belongs_to :product

  field :code_count, :type => Integer, :default => 1
  field :retail, :type => Boolean, :default => false
  field :notes, :type => String
  field :file_uid, :type => String
  image_accessor :file

  default_scope order_by(:created_at.desc)

  validates :code_count, :presence => true,
            :numericality => {
              :greater_than_or_equal_to => 1,
              :only_integer => true
            }

  validates :product_id, :presence => {
    :if => :retail?,
    :message => "is required if this is a retail batch"
  }

  delegate :chippd_product_type_ids, :name, :to => :product, :prefix => true

  def retail?
    retail
  end

  def fully_generated?
    codes.count == code_count
  end

  def number
    created_at.to_i
  end

  def generate!
    generator_class.call(self.to_param)
  end

  def codes_used
    codes.used.count
  end

  def percentage_used
    (codes_used.to_f / code_count.to_f) * 100
  end

  def chippd_product_type_ids
    retail? ? product_chippd_product_type_ids : []
  end

  protected

  def generator_class
    retail ? RetailBatchGenerator : BatchGenerator
  end
end
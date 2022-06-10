class Preorder
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  belongs_to :product

  field :email, :type => String

  validates :email, :presence => true,
    :format => {
      :with => configatron.email_regex,
      :message => "is not a valid email address"
    },
    :uniqueness => {
      :scope => :product_id
    }
end

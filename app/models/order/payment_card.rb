class PaymentCard
  include Mongoid::Document
  embedded_in :order

  field :brand, :type => String
  field :last4, :type => String
  field :exp_month, :type => String
  field :exp_year, :type => String
end

class Bid
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  belongs_to :customer
  embedded_in :auction

  field :amount,         :type => Integer # dollars
  field :notify_out_bid, :type => Boolean, :default => false
  field :notify_ending,  :type => Boolean, :default => false

  validates :amount, :presence     => true,
                     :numericality => { :only_integer => true, :greater_than_or_equal_to => 1 }

end

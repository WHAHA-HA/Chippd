class Address
  include Mongoid::Document
  embedded_in :order

  field :first_name, :type => String
  field :last_name, :type => String
  field :address_1, :type => String
  field :address_2, :type => String
  field :city, :type => String
  field :state, :type => String
  field :postal_code, :type => String
  field :country, :type => String, :default => 'United States'

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :address_1, :presence => true
  validates :city, :presence => true
  validates :state, :presence => true
  validates :postal_code, :presence => true
  validates :country, :presence => true
end

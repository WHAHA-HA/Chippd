class AddressPresenter < BasePresenter
  presents :address
  delegate :address_1, :address_2, :city, :state, :postal_code, :to => :address

  def name
    [address.first_name, address.last_name].join(' ')
  end

  def has_second_address_line?
    address.address_2.present?
  end
end
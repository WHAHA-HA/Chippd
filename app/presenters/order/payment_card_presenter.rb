class PaymentCardPresenter < BasePresenter
  presents :payment_card
  delegate :brand, :to => :payment_card

  def icon
    image_tag(brand_to_image_mappings[brand], :alt => brand, :title => brand)
  end

  def number
    "Ending in #{payment_card.last4}"
  end

  def expiration
    "Expiring #{payment_card.exp_month}/#{payment_card.exp_year}"
  end

protected

  def brand_to_image_mappings
    {
      'Visa' => 'icon-visa.png',
      'American Express' => 'icon-amex.png',
      'MasterCard' => 'icon-mastercard.png',
      'Discover' => 'icon-discover.png',
      'JCB' => 'icon-jcb.png',
      'Diners Club' => 'icon-dinersclub.png',
      'Unknown' => ''
    }
  end
end
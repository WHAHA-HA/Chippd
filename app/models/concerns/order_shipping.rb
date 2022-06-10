module OrderShipping
  extend ActiveSupport::Concern

  def number_of_units
    self.line_items.to_a.sum(&:quantity)
  end

  def shipping_via_ground?
    self.shipping_option == :ground
  end

  def qualifies_for_greeting_card_shipping?
    if line_items.any?(&:greeting_card?)
      if has_more_than_two_greeting_cards? || has_products_that_are_not_greeting_cards?
        false
      else
        true
      end
    else
      false
    end
  end

  protected

  def has_more_than_two_greeting_cards?
    line_items.select(&:greeting_card?).sum(&:quantity) > 2
  end

  def has_products_that_are_not_greeting_cards?
    line_items.select { |l| !l.greeting_card? }.sum(&:quantity) > 0
  end

end

module OrderState
  extend ActiveSupport::Concern

  included do
    extend ClassMethods

    field :state, :type => String, :default => 'cart'
    field :purchased_at, :type => DateTime
    field :shipped_at, :type => DateTime
    field :canceled_at, :type => DateTime
  end

  module ClassMethods
    def completed_states
      ['paid', 'shipped', 'canceled']
    end

    def paid
      where(:state => 'paid').order_by(:purchased_at.asc)
    end

    def shipped
      where(:state => 'shipped').order_by(:shipped_at.desc)
    end

    def canceled
      where(:state => 'canceled').order_by(:canceled_at.desc)
    end

    def complete
      where(:state.in => completed_states)
    end
  end

  def ship!
    transition_state!(:shipped)
  end

  def cancel!
    transition_state!(:canceled)
  end

  def paid?
    state_matches?('paid')
  end

  def shipped?
    state_matches?('shipped')
  end

  def canceled?
    state_matches?('canceled')
  end

  def complete?
    self.class.completed_states.include?(self.state)
  end

  protected

  def state_matches?(_state)
    self.state == _state
  end

  def transition_state!(new_state)
    self.send("#{new_state}_at=", Time.now)
    self.state = new_state
    if self.save
      OrderMailer.send(new_state, self.to_param).deliver
      true
    else
      false
    end
  end

  def has_more_than_two_greeting_cards?
    line_items.select(&:greeting_card?).sum(&:quantity) > 2
  end

  def has_products_that_are_not_greeting_cards?
    line_items.select { |l| !l.greeting_card? }.sum(&:quantity) > 0
  end
end

class CustomerMailer < BaseMailer

  def welcome(customer_id)
    fetch_customer(customer_id)
    mail :to => @customer.email, :subject => "Welcome to Chipp'd!"
  end

  def reset_password_instructions(customer_id)
    fetch_customer(customer_id)
    mail :to => @customer.email, :subject => "Reset your password"
  end

  def confirmation_instructions(customer_id)
    fetch_customer(customer_id)
    mail :to => @customer.email, :subject => "Chipp'd Confirmation Instructions"
  end

  def auction_ending(customer_id)
    fetch_customer(customer_id)
    mail :to => @customer.email, :subject => "Auction ending in 5 minutes!"
  end

  def auction_outbid(customer_id)
    fetch_customer(customer_id)
    mail :to => @customer.email, :subject => "You have just been outbid!"
  end

  def auction_over(customer_id, auction_id)
    fetch_customer(customer_id)
    fetch_auction(auction_id)
    mail :to => @customer.email, :subject => "Auction Has Ended"
  end

  def auction_won(customer_id, auction_id)
    fetch_customer(customer_id)
    fetch_auction(auction_id)
    mail :to => @customer.email, :subject => "We Have a Winner!"
  end

  protected

  def fetch_customer(customer_id)
    @customer = Customer.find(customer_id)
  end

  def fetch_auction(auction_id)
    @auction = Page.find_and_return_section(auction_id)
  end

end

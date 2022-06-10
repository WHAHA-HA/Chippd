class ContactRequestMailer < BaseMailer

  def contact_request(email, topic, message)
    @topic = topic
    @email = email
    @message = message

    mail :to => configatron.email_addresses.notification, :subject => "A new contact request has been received."
  end
end

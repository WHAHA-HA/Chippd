class AdminMailer < BaseMailer

  def processing_failed(message)
    @message = message
    mail :to => configatron.email_addresses.exceptions, :subject => "An asset processing exception has occurred."
  end

end

class BaseMailer < ActionMailer::Base
  default :from => %{Chipp'd <#{configatron.email_addresses.do_not_reply}>}
  layout 'email'
  helper :email
end

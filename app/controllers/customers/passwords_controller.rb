class Customers::PasswordsController < Devise::PasswordsController
  protected

  def default_meta_tags
    super.merge!({
      :site => "Reset Your Chipp'd Password.",
      :title => "Don't Worry, Stuff Happens"
    })
  end
end

class Customers::SessionsController < Devise::SessionsController
  protected

  def default_meta_tags
    super.merge!({
      :site => "Sign In to Chipp'd.",
      :title => 'Until We Figure Out a Better Way'
    })
  end
end

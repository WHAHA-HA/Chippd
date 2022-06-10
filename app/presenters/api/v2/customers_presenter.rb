class Api::V2::CustomersPresenter < Api::V1::CustomersPresenter
  def as_json(options = {})
    {
      :customer => {
        :first_name => object.first_name,
        :last_name => object.last_name,
        :email => object.email,
        :authentication_token => object.authentication_token
      }
    }
  end
end

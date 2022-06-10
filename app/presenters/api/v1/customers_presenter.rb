class Api::V1::CustomersPresenter < Api::V1::BasePresenter
  def as_json(options = {})
    {
      :customer => {
        :name => object.full_name,
        :email => object.email,
        :authentication_token => object.authentication_token
      }
    }
  end
end

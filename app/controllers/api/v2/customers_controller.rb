class Api::V2::CustomersController < Api::V1::CustomersController
  def sign_in
    super
  end

  protected

  def presenter_klass
    Api::V2::CustomersPresenter
  end

  def enforce_special_validations!
  end
end

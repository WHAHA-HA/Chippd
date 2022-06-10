class Api::V1::CustomersController < Api::V1::BaseController
  skip_after_filter :handle_device_information

  def create
    @customer = Customer.new(params[:customer])
    enforce_special_validations!
    if @customer.save
      CustomerMailer.welcome(@customer.to_param).deliver
      render :json => presenter_klass.new(@customer), :status => :created
    else
      render :json => Api::V1::ErrorsPresenter.new(@customer.errors), :status => :unprocessable_entity
    end
  end

  def sign_in
    customer = Customer.find_for_database_authentication(:email => params[:email])
    if customer && customer.valid_password?(params[:password])
      @current_customer = customer
      render :json => presenter_klass.new(current_customer), :status => :ok
    else
      head :unauthorized
    end
  end

  protected

  def presenter_klass
    Api::V1::CustomersPresenter
  end

  def enforce_special_validations!
    @customer.v1_api!
  end
end

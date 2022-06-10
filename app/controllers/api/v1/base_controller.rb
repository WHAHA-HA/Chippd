class Api::V1::BaseController < ApplicationController
  respond_to :json

  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_application!
  before_filter :json_params_preprocessor
  after_filter :handle_device_information

  protected

  def headers
    @headers ||= HeaderSanitizer.sanitize!(env.dup)
  end

  def current_application
    @current_application ||= MobileAuthenticator.authenticated_application?(headers[:application_token])
  end

  def authenticate_application!
    head :unauthorized unless current_application
  end

  def account_token
    headers[:account_token]
  end

  def current_customer
    @current_customer ||= Customer.find_for_token_authentication(:authentication_token => account_token)
  end

  def authenticate_customer!
    head :unauthorized unless current_customer
  end

  def json_params_preprocessor
    if %w(POST PUT DELETE).include?(request.request_method)
      request_body = request.body.read
      params.merge!(Yajl::Parser.parse(request_body)) if request_body.present?
    end
  end

  def handle_device_information
    DeviceWorker.perform_async(current_customer.to_param, headers) if current_customer
  end

  def ios_legacy?
    MobileAuthenticator.ios_legacy?(headers[:application_token])
  end
end

class MyChippd::BaseController < ApplicationController
  before_filter :authenticate_customer!
  before_filter :set_my_chippd
  before_bugsnag_notify :add_customer_info_to_bugsnag
  skip_before_filter :verify_authenticity_token, only: [:pusher_auth]

  def index
    redirect_to my_chippd_pages_url
  end

  def pusher_auth
    response = Pusher[params[:channel_name]].authenticate(params[:socket_id])
    render json: response
  end

  protected

  def set_my_chippd
    @my_chippd = true
  end

  def add_customer_info_to_bugsnag(notification)
    # Add some app-specific data which will be displayed on a custom
    # "User Info" tab on each error page on bugsnag.com
    notification.add_tab(:customer_info, {
      :name => current_customer.full_name,
      :id => current_customer.to_param
    })
  end
end

class ContactRequestsController < ApplicationController
  before_filter :setup_subnav

  def new
    @contact_request = ContactRequest.new(params[:contact_request])
  end

  def create
    @contact_request = ContactRequest.new(params[:contact_request])

    if @contact_request.save
      ContactRequestMailer.contact_request(@contact_request.email, @contact_request.topic, @contact_request.message).deliver
      redirect_to contact_request_thank_you_url
    else
      render 'new'
    end
  end

  def thank_you
  end

  protected

  def current_subnav_path
    @current_subnav_path ||= contact_us_path
  end

  def default_meta_tags
    super.merge!({
      :site => "Contact Chipp'd.",
      :title => "Ask Us Anything"
    })
  end
end
